From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH,RFC] Adding quotacheck functionality to e2fsck
Date: Mon, 29 Mar 2010 11:35:51 +0400
Message-ID: <87ljdblgvc.fsf@openvz.org>
References: <E1NuxHe-0005cj-JN@closure.thunk.org>
	<20100326004738.GJ3145@quack.suse.cz>
	<20100326033824.GC21658@thunk.org>
	<9E7C0FF6-B02F-4470-B70A-4DBF5D5D6E0E@oracle.com>
	<87hbo37ay3.fsf@openvz.org> <20100326105733.GC3055@quack.suse.cz>
	<87y6hfibac.fsf@openvz.org> <87tys3hwvd.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <andreas.dilger@oracle.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:11038 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab0C2HgK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 03:36:10 -0400
In-Reply-To: <87tys3hwvd.fsf@openvz.org> (Dmitry Monakhov's message of "Fri,
	26 Mar 2010 19:27:02 +0300")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov <dmonakhov@openvz.org> writes:

> Dmitry Monakhov <dmonakhov@openvz.org> writes:
>
>> Jan Kara <jack@suse.cz> writes:
>>
>>> On Fri 26-03-10 11:18:28, Dmitry Monakhov wrote:
>>>> > If there isn't a reason to continue using unjournaled quota (i.e. it
>>>> > doesn't break to just move to journaled quota everywhere), then these
>>>> > could just become aliases for the journaled quota implementation.  The
>>>> > other alternative is to deprecate these options in the next kernel and
>>>> > have it print out a warning on the console to tell the user to switch
>>>> > over to the journaled version.
>>>> The only reason to not use journalled quota by default is the currently
>>>> it is a bit slower than unjournalled variant.
>>>> This is because each quota change result in synchronous quotafile 
>>>> update in per-sb-page-cache. And this update is protected by i_mutex.
>>>> and dqio_mutex. It may be fixed easily. I've sent a RFC patch two
>>>> month ago. I'll update it and will submit it this weekend. 
>>>   Well, there is also some overhead caused by more IO we have to do for
>>> quota journaling and that is essentially unavoidable. But still I believe
>>> we should transition people to journaled quotas...
>> Agree. IO overhead due to journalled quota is almost invisible.
>> And it must be enabled by default after most annoying lock contention
>> will be resolved.
>>
>> BTW. i've had bad news. Seems what journalled was broken recently.
>> Right after i've wrote the first letter. i've started to update the
>> quota-speedup patch. And during testing phase i've found that
>> journalled quota is inconsistent after power-failure(w/o my patches).
>> I've tested ext4.git/for-next branch
>> Currently i'm investing the issue.
> Ok, i've found the root of issue. dquot_transfer() wasn't called for
> symlinks on chown due to lack of ->setattr operation.
> Before 'dquot: cleanup dquot transfer routine' patch quota_transfer()
> was performed by notify_transfer() itself.
Forgot to mention that it is not journalled quota issue. But just a
generic quota regression.
> Now it must be handled by in corresponding ->setattr
>
> BTW i'm wondering, even if we don't care about quota. Inode's attributes
> are metadata and must goes trough journal(i.e via extXXX_setattr).
> so every inode type must has corresponding ->setattr.
As is is always happens. Each modification result in unexpected regressions.
In case of quota cleanup patch-set movement of quota-transfer from
generic-setattr to fs-speciffic ->setattr result in hidden regression
because not all inode types has correct ->setattr methods.
Where are too many filesystems to look-at. Let's add a some
sanity check in to notify_changes(), and remove it after 2/3 moths.

Some thing like this:
static int quota_check(struct inode *inode, struct iattr *attr)
{
        if (!sb_any_quota_active(inode->i_sb))
                return 0;
        if (((attr->ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
                (attr->ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid) ||
                (attr->ia_valid & ATTR_SIZE)) && !inode->i_op->setattr)
                {
                WARN_ON(1);
                return 1;
        }
        return 0;
}

