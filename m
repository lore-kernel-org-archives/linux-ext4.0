From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: [PATCH, RFC] Ext4: Mount partition as read only if during orphan
 cleanup truncate fails to obtain journal handle.
Date: Fri, 7 Dec 2012 14:52:02 +0530
Message-ID: <CAOiN93n_5t4WD5yzijhDxJ9sZfk6M=baBRnDg5u7Xo+mdX=upQ@mail.gmail.com>
References: <1351075240-2725-1-git-send-email-ashish.sangwan2@gmail.com>
	<CAKYAXd_6pHdPtOgOS4=_c6naWwPdMhna29OOKD919HrYM-+kaA@mail.gmail.com>
	<CAOiN93nKkFAc_t6J+c1w4F3V-MYaq9cv2wfAq3hyniWz5wYFMw@mail.gmail.com>
	<20121206170938.GC30273@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Theodore Ts'o" <tytso@mit.edu>,
	Namjae Jeon <linkinjeon@gmail.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	=?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56676 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab2LGJWE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Dec 2012 04:22:04 -0500
In-Reply-To: <20121206170938.GC30273@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 6, 2012 at 10:39 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Thu, Dec 06, 2012 at 04:59:43PM +0530, Ashish Sangwan wrote:
>>
>> Did you get any time to look into this patch?
>> This problem is with ext4 only as ext4_truncate does not clean the
>> orphan list unlike that of ext3_truncate.
>> Instead, in case of failure to obtain handle, orphan list cleanup is
>> done in ext4_setattr.
>> But during mount, ext4_truncate is not called via ext4_setattr and
>> hence the problem.
>> What do you think?
>
> In the patch description, you mentioned that this occurs when the
> there is a failure to obtain a journal handle.  Is this a hypothetical
> thing that you exposed via some kind of tester which checks to see
> what happens if kmalloc() randomly fails some number of allocation
> requests?  Or was it happening in real life?  And if it is happening
> in real life, do we understand why it's happening, and is there
> something we should be doing to mitigate against the root cause of the
> failure?
>
Thanks for looking into the patch.
Yes, you are right. The situation is hypothetical.
We were checking about Ext4's behavior when it returns error at
different points in truncate/hole punch path and that's when we
stumbled on to this.
In real, we cannot re-produce this scenario without modifying Ext4's
code and hence an extra RFC added with the patch.
If you think that obtaining journal handle could never fail at mount
time, than please ignore this patch.

> The alternative to your patch is to do something similar to what ext3
> does.  That is, if there are any inodes left on the orphan list, to
> iterate through them all and then clean up the orphan list.  Perhaps
> we should then also call ext4_error() since technically the file
> system may very well be inconsistent (there may be allocated inodes
> holding blocks which are no longer connected the directory hierarchy,
> which e2fsck would be able to clean up).  But that could potentially
> cause the system to panic or remount the file system read-only,
> depending on what the errors= behavior is set to.  Which is why I go
> back to the original question; do we understand why ext4_truncate()
> was failing during orphan cleanup in the first place?
>
>                                                - Ted

Right, using ext4_error() would have been a better choice than
explicitly setting RO flag.
I wonder why ext4_truncate does not clear the orphan_list in case of
failure to obtain journal handle unlike that of ext3_truncate?
We would not have to bother about explicitly clearing the orphan list
in the first place if we could just add a lable like out_notrans (as
in ext3)=>
 if (IS_ERR(handle))
                goto out_notrans;

 out_notrans:
        /*
         * Delete the inode from orphan list so that it doesn't stay there
         * forever and trigger assertion on umount.
         */
        if (inode->i_nlink)
                ext3_orphan_del(NULL, inode);

Regards,
Ashish
