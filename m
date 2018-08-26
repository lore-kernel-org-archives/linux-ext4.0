From: Gao Xiang via Linux-f2fs-devel <linux-f2fs-devel@lists.sourceforge.net>
Subject: Re: [RFC PATCH 02/10] fs-verity: add data verification
 hooks for ->readpages()
Date: Mon, 27 Aug 2018 01:44:50 +0800
Message-ID: <a83219f8-44a2-7a40-319a-dc2f9d567cbe@aol.com>
References: <20180824161642.1144-1-ebiggers@kernel.org>
 <20180824161642.1144-3-ebiggers@kernel.org>
 <C86750D6-CA95-4A7F-9204-51345C497EC2@gmail.com>
 <20180826170433.GA728@sol.localdomain>
Reply-To: Gao Xiang <hsiangkao@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Chuck Lever <chucklever@gmail.com>,
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
 Michael Halcrow <mhalcrow@google.com>, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-ext4@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>,
 Victor Hsieh <victorhsieh@google.com>
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20180826170433.GA728@sol.localdomain>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

Hi Eric,

On 2018/8/27 1:04, Eric Biggers wrote:
> Hi Chuck,
> 
> On Sun, Aug 26, 2018 at 11:55:57AM -0400, Chuck Lever wrote:
>>> +
>>> +/**
>>> + * fsverity_verify_page - verify a data page
>>> + *
>>> + * Verify a page that has just been read from a file against that file's Merkle
>>> + * tree.  The page is assumed to be a pagecache page.
>>> + *
>>> + * Return: true if the page is valid, else false.
>>> + */
>>> +bool fsverity_verify_page(struct page *data_page)
>>> +{
>>> +	struct inode *inode = data_page->mapping->host;
>>> +	const struct fsverity_info *vi = get_fsverity_info(inode);
>>> +	struct ahash_request *req;
>>> +	bool valid;
>>> +
>>> +	req = ahash_request_alloc(vi->hash_alg->tfm, GFP_KERNEL);

Some minor suggestions occurred to me after I saw this part of code
again before sleeping...

1) How about introducing an iterator callback to avoid too many
ahash_request_alloc and ahash_request_free... (It seems too many pages
and could be some slower than fsverity_verify_bio...)

2) How about adding a gfp_t input argument since I don't know whether
GFP_KERNEL is suitable for all use cases...

It seems there could be more fsverity_verify_page users as well as
fsverity_verify_bio ;)

Sorry for interruption...

Thanks,
Gao Xiang

>>> +	if (unlikely(!req))
>>> +		return false;
>>> +
>>> +	valid = verify_page(inode, vi, req, data_page);
>>> +
>>> +	ahash_request_free(req);
>>> +
>>> +	return valid;
>>> +}
>>> +EXPORT_SYMBOL_GPL(fsverity_verify_page);
>>> +
>>> +/**
>>> + * fsverity_verify_bio - verify a 'read' bio that has just completed
>>> + *
>>> + * Verify a set of pages that have just been read from a file against that
>>> + * file's Merkle tree.  The pages are assumed to be pagecache pages.  Pages that
>>> + * fail verification are set to the Error state.  Verification is skipped for
>>> + * pages already in the Error state, e.g. due to fscrypt decryption failure.
>>> + */
>>> +void fsverity_verify_bio(struct bio *bio)
>>
>> Hi Eric-
>>
>> This kind of API won't work for remote filesystems, which do not use
>> "struct bio" to do their I/O. Could a remote filesystem solely use
>> fsverity_verify_page instead?
>>
> 
> Yes, filesystems don't have to use fsverity_verify_bio().  They can call
> fsverity_verify_page() on each page instead.  I will clarify this in the next
> revision of the patchset.
> 
> - Eric
> 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
