From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [PATCH 5 2/4] Return 32/64-bit dir name hash according to usage
 type
Date: Tue, 24 Apr 2012 23:07:14 +0200
Message-ID: <4F971602.7090005@itwm.fraunhofer.de>
References: <20120109132137.2616029.76288.stgit@localhost.localdomain> <20120109132148.2616029.68798.stgit@localhost.localdomain> <4F91C15B.6070200@redhat.com> <4F93FED6.6090505@itwm.fraunhofer.de> <4F95BD72.6090200@redhat.com> <4F95C109.1030401@itwm.fraunhofer.de> <4F95D65A.8070608@redhat.com> <A754D23B-B946-4E80-ACEA-0E2C2E6FAA2E@whamcloud.com> <4F96D08B.2020606@itwm.fraunhofer.de> <4F96FD45.9080902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@whamcloud.com>, linux-ext4@vger.kernel.org,
	Fan Yong <yong.fan@whamcloud.com>, bfields@redhat.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58441 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631Ab2DXVH0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Apr 2012 17:07:26 -0400
In-Reply-To: <4F96FD45.9080902@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/24/2012 09:21 PM, Eric Sandeen wrote:
> On 4/24/12 11:10 AM, Bernd Schubert wrote:
>> On 04/24/2012 12:42 AM, Andreas Dilger wrote:
>>> On 2012-04-23, at 5:23 PM, Eric Sandeen wrote:
>>>> I'm curious about the above as well as:
>>>>
>>>>         case SEEK_END:
>>>>                 if (unlikely(offset>  0))
>>>>                         goto out_err; /* not supported for directories */
>>>>
>>>> The previous .llseek handler, and the generic handler for other
>>>> filesystems, allow seeking past the end of the dir AFAICT. (not
>>>> sure why you'd want to, but I don't see that you'd get an error
>>>> back).
>>>>
>>>> Is there a reason to uniquely exclude it in ext4?  Does that line up with POSIX?
>>>
>>> I don't know what the origin of this was... I don't think there is
>>> a real reason for it except that it doesn't make any sense to do
>>> so.
>>>
>>
>> I think I added that. According to pubs.opengroup.org:
>> (http://pubs.opengroup.org/onlinepubs/009695399/functions/seekdir.html)
>>
>> void seekdir(DIR *dirp, long loc);
>>
>> <quote>
>>
>> If the value of loc was not obtained from an earlier call to
>> telldir(), or if a call to rewinddir() occurred between the call to
>> telldir() and the call to seekdir(), the results of subsequent calls
>> to readdir() are unspecified.
>>
>> </quote>
>>
>>
>> As telldir(), which should correlate to 'case SEEK_CUR' will not
>> provide invalid values, the behaviour is undefined.
>>
>>
>> Also,
>>
>>
>> case SEEK_END:
>> [...]
>>                 if (dx_dir)
>>                         offset += ext4_get_htree_eof(file);
>>                 else
>>                         offset += inode->i_size;
>> [...]
>>
>>
>>         if (!dx_dir) {
>>                 if (offset > inode->i_sb->s_maxbytes)
>>                         goto out_err;
>>         } else if (offset > ext4_get_htree_eof(file))
>>                 goto out_err;
>>
>>
>>
>>
>> Hence, the additional:
>>
>>          case SEEK_END:
>>                  if (unlikely(offset>  0))
>>                       goto out_err; /* not supported for directories */
>>
>>     
>> is just a shortcut to avoid useless calculations.
>>
>> Unless I missed something, it only remains the question if could
>> break existing applications relying on undefined behaviour. However,
>> I have no idea how an application might trigger that?
> 
> (other lists removed at this point, this is ext4-specific)
> 
> I know I'm being a little pedantic w/ the late review here....

That is fine, lets better be pedantic now than cause trouble to ext4
users...

> 
> It seems like the only differences between ext4_dir_llseek and the old ext4_llseek are these:
> 
> 1) For SEEK_END, we now return -EINVAL for a positive offset (i.e. past EOF)

I definitely introduces that one, as I cannot see how an application
might ever run into it. Especially as ext4 directories cannot shrink. So
if an application tries to exceed the directory size limit, it looks to
me as some of attempt to break something or as an error in the
application. However, if there should be the slightest chance to break
existing applications relying on that, we need to remove that.



I thought about 2) and 3) it on my way home and I think I remembered the
reason for it.

> 2) For SEEK_END, we seek to ext4_get_htree_eof() not to inode->i_size

Lets assume an application wants to seek to the last directory entry. If
it would seek to inode->i_size and then would attempt another readdir
from that offset, we probably would succeed, as inode->i_size is
probably just an arbitrary value in between two hashes, or even smaller
than the very first hash  value, so the next readdir() probably even
would read the very first  directory entry. I think i_size and
ext4_get_htree_eof()  makes a very big difference here.

> 3) For SEEK_SET, we impose different limits for max offset
>   - s_maxbytes / ext4_get_htree_eof for !dx/dx, vs. s_bitmap_maxbytes/s_maxbytes

Its a bit too late for me to check that today (and I'm almost
starving...), but is it possible that s_maxbytes is smaller than
ext4_get_htree_eof? So is possible that valid hash values get larger
than s_maxbytes? I will check that tomorrow morning.

> 
> Do any of these changes relate to the hash collision problem?  Are any of them uniquely
> required for ext4, enough to warrant cut & paste of the vfs llseek code (again?)
> 
> What I'm getting at is: what are the reasons that we cannot use generic_file_llseek_size(),
> maybe with a new argument to specify a non-standard location for SEEK_END.  Such
> a change would require a solid explanation, but it'd probably go in if it meant
> one less seek implementation to worry about.


I think we probably need to extent generic_file_llseek_size() by a
parameter 'max_fs_limit' (well something like that name, I don't find a
better one now) and then it should be possible to use it.


Cheers,
Bernd


