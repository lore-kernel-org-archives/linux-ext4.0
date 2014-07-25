From: JP Abgrall <jpa@google.com>
Subject: Re: [PATCH] ext4: Add support for FIDTRIM, a best-effort ioctl for
 deep discard trim
Date: Thu, 24 Jul 2014 18:50:22 -0700
Message-ID: <CAKP4w2TzDu6d=hK+21GnZU6Sd_gH8icJ=XA3q23Oa9Bd9fF6uA@mail.gmail.com>
References: <1406159238-7557-1-git-send-email-jpa@google.com> <20140724120801.GA26465@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Geremy Condra <gcondra@google.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:36666 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984AbaGYBun (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jul 2014 21:50:43 -0400
Received: by mail-oa0-f44.google.com with SMTP id eb12so4829279oac.31
        for <linux-ext4@vger.kernel.org>; Thu, 24 Jul 2014 18:50:43 -0700 (PDT)
In-Reply-To: <20140724120801.GA26465@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 24, 2014 at 5:08 AM, Dave Chinner <david@fromorbit.com> wrote:
>
> On Wed, Jul 23, 2014 at 04:47:18PM -0700, JP Abgrall wrote:
> > +#define FIDTRIM      _IOWR('X', 122, struct fstrim_range)    /* Deep discard trim */
>
> The 'X' ioctl namespace is actually XFS's ioctl namespace. FIDTRIM
> should be in the 'f' namespace
Ok.
How should the next sequence number be handled?
Go with ('f', 122,...) after FITRIM, or go with ('f', 12,...) after
FS_IOC_FIEMAP ('f' namepsace)?
