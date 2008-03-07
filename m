From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: [PATCH] [RFC] New fsck option to ignore device-mapper crypto
	devices
Date: Fri, 07 Mar 2008 09:19:47 -0600
Message-ID: <1204903187.7975.10.camel@norville.austin.ibm.com>
References: <n7xejaoynp9.fsf@sor.suse.de>
	 <1204813967.8679.28.camel@norville.austin.ibm.com>
	 <n7xzltbwzq3.fsf@sor.suse.de>
	 <1204824227.7964.4.camel@norville.austin.ibm.com>
	 <n7xiqzywr7u.fsf@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>, ludwig.nussel@suse.de,
	linux-ext4@vger.kernel.org
To: Matthias Koenig <mkoenig@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60909 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbYCGPTv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Mar 2008 10:19:51 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m27FJoEM012177
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 10:19:50 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m27FJoQ2243868
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 10:19:50 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m27FJotL000698
	for <linux-ext4@vger.kernel.org>; Fri, 7 Mar 2008 10:19:50 -0500
In-Reply-To: <n7xiqzywr7u.fsf@sor.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Fri, 2008-03-07 at 15:20 +0100, Matthias Koenig wrote:
> Dave Kleikamp <shaggy@linux.vnet.ibm.com> writes:
> 
> > On Thu, 2008-03-06 at 18:04 +0100, Matthias Koenig wrote:
> >> Dave Kleikamp <shaggy@linux.vnet.ibm.com> writes:
> >
> >> > Should field 8 of /etc/fstab (fs_passno) be zero for these mount points?
> >> > Is there any reason for it to be anything different?
> >> 
> >> Why? zero would mean that they should never get checked.
> >> I think it is reasonable to have the choice to get your crypto
> >> filesystems checked. Current practise for SuSE has been to allow
> >> only 0, but checked this filesystem anyway, which has lead to complaints.
> >> So we want to do this more consistent.
> >
> > Zero tells fsck not to check the filesystem during reboot.  It's what
> > tells fsck -A which filesystems to check.  If we don't expect the
> > filesystem to be check-able during that phase, a non-zero value won't
> > have any real meaning.
> 
> I see, but what are we doing with crypto filesystems for which the devices
> simply do not exist at this phase in the boot process?

I don't understand the question.  If the fs_passno field is zero, fsck
isn't even going to try to check the filesystem, so having no device is
no problem.

> How should we specify that we want these filesystems to be checked or not 
> at a later time in the boot process after the crypto devices have been
> set up?

This is why I asked if fsck was being run with the -A flag in step d.
If it's not, then I'm not clear on why fs_passno has anything to do with
it.  Is there some script that looks at this field in /etc/fstab for
step d?

If that's the case, then I suggest a more general solution.  Either some
special value for fs_passno that defers the fsck for a later pass, or a
simplified version of your proposed patch without the crypto-specific
part.
-- 
David Kleikamp
IBM Linux Technology Center

