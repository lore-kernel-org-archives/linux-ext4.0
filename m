From: Johann Lombardi <johann@whamcloud.com>
Subject: Re: [PATCH v3] ext4: make quota as first class supported feature
Date: Mon, 7 Nov 2011 21:35:28 +0100
Message-ID: <20111107203528.GA3191@granier.hd.free.fr>
References: <1320372920-21308-1-git-send-email-adityakali@google.com>
 <20111104092022.GD6205@granier.hd.free.fr>
 <CAGr1F2GfixM0m0Hz7eK7CNJHY40Rpxi2szYXw=PT9jZaqSncBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58178 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab1KGUjh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Nov 2011 15:39:37 -0500
Received: by eye27 with SMTP id 27so3858901eye.19
        for <linux-ext4@vger.kernel.org>; Mon, 07 Nov 2011 12:39:36 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAGr1F2GfixM0m0Hz7eK7CNJHY40Rpxi2szYXw=PT9jZaqSncBg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 04, 2011 at 10:43:10AM -0700, Aditya Kali wrote:
> On Fri, Nov 4, 2011 at 2:20 AM, Johann Lombardi <johann@whamcloud.com=
> wrote:
> > On Thu, Nov 03, 2011 at 07:15:20PM -0700, Aditya Kali wrote:
> >> +#ifdef CONFIG_QUOTA
> >> + =A0 =A0 /* Enable quota usage during mount. */
> >> + =A0 =A0 if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPA=
T_QUOTA) &&
> >> + =A0 =A0 =A0 =A0 !(sb->s_flags & MS_RDONLY)) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_quota_enable(sb, USRQUOTA, QFMT_VFS=
_V1,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DQUO=
T_USAGE_ENABLED);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_quota_enable(sb, GRPQUOTA, QFMT_VFS=
_V1,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DQUO=
T_USAGE_ENABLED);
> >
> > I think we should print an error message if one of the calls to ext=
4_quota_enable() failed. Space accounting in the quota files won't be a=
ccurate any more and e2fsck is required.
>=20
> Are you suggesting that we mark the filesystem has having errors if
> this fails (use ext4_error() ) or simply print a warning in dmesg?

A warning in dmesg is the least we could do IMHO. Marking the filesyste=
m as having errors would be even better, i think.
BTW, we have the same problem if CONFIG_QUOTA is not defined.

> I am currently marking the filesystem as having errors if ext4_iget()
> fails for the quota inode. But dquot_enable() could fail for other
> reasons too (specially if we allow using user-specified quota files).

Cheers,
Johann
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
