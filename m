From: Dmitriy Monakhov <dmonakhov@sw.ru>
Subject: Re: [PATCH] ext3: dirindex error pointer issues
Date: Mon, 05 Mar 2007 10:34:08 +0300
Message-ID: <87k5xwkutr.fsf@sw.ru>
References: <87lkidf5y0.fsf@sw.ru>
	<20070305021344.GO6662@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:45735 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbXCEHdp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Mar 2007 02:33:45 -0500
In-Reply-To: <20070305021344.GO6662@schatzie.adilger.int> (Andreas Dilger's message of "Mon, 5 Mar 2007 10:13:44 +0800")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger <adilger@clusterfs.com> writes:

> On Mar 04, 2007  17:18 +0300, Dmitriy Monakhov wrote:
>>  - ext3_dx_find_entry() exit with out setting proper error pointer
>>  - do_split() exit with out setting proper error pointer
>>    it is realy painful because many callers contain folowing code:
>>            de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
>>            if (!(de))
>>                         return retval;
>>            <<< WOW retval wasn't changed by do_split(), so caller failed
>>            <<< but return SUCCESS :)
>>  - Rearrange do_split() error path. Current error path is realy ugly, all
>>    this up and down jump stuff doesn't make code easy to understand.
>> 
>> Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
>> ---
>>  fs/ext3/namei.c |   26 +++++++++++++++-----------
>>  fs/ext4/namei.c |   26 +++++++++++++++-----------
>>  2 files changed, 30 insertions(+), 22 deletions(-)
>> 
>> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
>> index 49159f1..1a52586 100644
>> --- a/fs/ext3/namei.c
>> +++ b/fs/ext3/namei.c
>> @@ -969,6 +969,7 @@ static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
>>  				  (block<<EXT3_BLOCK_SIZE_BITS(sb))
>>  					  +((char *)de - bh->b_data))) {
>>  				brelse (bh);
>> +				*err = ERR_BAD_DX_DIR;
>>  				goto errout;
>>  			}
>>  			*res_dir = de;
>
> I have no objection to this change (by principle of least surprise) but
> I don't know if it fixes a real problem.  The one caller of this function
> treats ERR_BAD_DX_DIR the same as bh == NULL.
  Execly  ERR_BAD_DX_DIR treats  the same as bh == NULL and let's look at
  callers code: 
  struct buffer_head * ext3_find_entry(......)
  {
  .......
              bh = ext3_dx_find_entry(dentry, res_dir, &err);
                /*
                 * On success, or if the error was file not found,
                 * return.  Otherwise, fall back to doing a search the
                 * old fashioned way.
                 */
                if (bh || (err != ERR_BAD_DX_DIR))
  <<<<< after ext3_dx_find_entry() has failed , but don't set err pointer 
  <<<<< we get  (bh == NULL, err == 0) , and then just return NULL.
                        return bh;
 .......
 }

>
>> @@ -1134,9 +1135,9 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
>>  	char *data1 = (*bh)->b_data, *data2;
>>  	unsigned split;
>>  	struct ext3_dir_entry_2 *de = NULL, *de2;
>> -	int	err;
>> +	int	err = 0;
>>  
>> -	bh2 = ext3_append (handle, dir, &newblock, error);
>> +	bh2 = ext3_append (handle, dir, &newblock, &err);
>
> Why don't we just remove "err" entirely and use *error to avoid any risk
> of setting err and not returning it in error?  Also reduces stack usage
> that tiny little bit.
I've chosen this approuch becouse of:
1) this approuch was used in block allocation code.
2) this approuch prevent  folowing errors:
  *error = do_some_function(.....)
  ........ /* some code*/
  if(error) 
 we do this checking as we do it thousands times before, but forget
 what error it pointer here. And compiler can't warn us here because 
 it is absolutely legal operation. At least it is better to rename 
 error to errorp.

Btw: I've thought about adding assertations to error path witch may check
what errp pointer was properly initialized after error happends.
folowing code is draft only:
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -63,6 +63,7 @@ static struct buffer_head *ext3_append(handle_t *handle,
 		EXT3_I(inode)->i_disksize = inode->i_size;
 		ext3_journal_get_write_access(handle,bh);
 	}
+	assert(bh || *err);
 	return bh;
 }
 
@@ -433,6 +434,7 @@ fail2:
 		frame--;
 	}
 fail:
+	assert(*err != 0);
 	return NULL;
 }

>
>
> In ext3_dx_add_entry() it appears like we should "goto journal_error"
> to report an error after the failed call to do_split(), instead of just
> "goto cleanup" so that we report an error in the filesystem.  Not 100%
> sure of this.
do_split() already invoked ext3_std_error() on it's "journal_error" path.

>
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
