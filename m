From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH V5 00/23] ext4: Add inline data support.
Date: Tue, 14 Aug 2012 20:51:40 -0600
Message-ID: <C51423EF-8C77-40E3-AD8F-0366EB4096E4@dilger.ca>
References: <1341070917-4889-1-git-send-email-tm@tao.ma> <20120813150445.GC13072@thunk.org> <5029F88F.7090106@tao.ma> <20120814151926.GA19364@thunk.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Tao Ma <tm@tao.ma>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail111c7-2520.megamailservers.com ([69.49.98.21]:43840 "EHLO
	mail111c7.megamailservers.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751251Ab2HOCvl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Aug 2012 22:51:41 -0400
In-Reply-To: <20120814151926.GA19364@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-08-14, at 9:19, Theodore Ts'o <tytso@mit.edu> wrote:

> On Tue, Aug 14, 2012 at 03:04:47PM +0800, Tao Ma wrote:
>> As andreas said in another e-mail, that would make the codes a little
>> complex. So in general, in my previous version, I just tried to refactor
>> most of the codes so that they can work for both inline inode and dir
>> blocks. But if these changes are merged, we have to re-write all of the
>> codes that are currently shared, such as ext4_find_entry, empty_dir,
>> ext4_add_entry etc.
> 
> Well, we may not need to rewrite as much as you think.  For one thing,
> as I mentioned, I don't think the VFS passes '.' and '..' lookup
> requests down to the file system anyway, and even if it did, you could
> just have a function which checks for '.' and '..' and returns the
> correct value if necessary.

Actually, NFS can submit lookups for ".." for path linkage IIRC, since we had to implement a patch to fix this for ext4 and Lustre at one time.

> So I think you wouldn't need to rewrite
> all of these functions, since the fundamental layout of the directory
> wouldn't be changing.  It's just that we're skipping the '.' and '..'
> entries, and the "standard" directory layout would be starting 4 bytes
> later (after the '..' inode number).

Agreed, the "." and ".." lookups are already special cases in the lookup code.

Cheers, Andreas

> So it's probably worth taking a look to see how much of an increase in
> complexity would actually be involved.
> 
> Regards,
> 
>                    - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
