From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Next3 on-disk format change request
Date: Thu, 24 Jun 2010 08:33:47 +0300
Message-ID: <AANLkTil17qZWKJfFsV77yADzxOffB2w94GN0COQyR82n@mail.gmail.com>
References: <AANLkTikAoKpZNGvtyYscPLVH1HrW3xaCZ84sVc62UGD4@mail.gmail.com>
	<20100624003529.GF6843@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49841 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab0FXFdt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jun 2010 01:33:49 -0400
Received: by fxm3 with SMTP id 3so40157fxm.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Jun 2010 22:33:47 -0700 (PDT)
In-Reply-To: <20100624003529.GF6843@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 24, 2010 at 3:35 AM,  <tytso@mit.edu> wrote:
> On Tue, Jun 22, 2010 at 01:30:54PM +0300, Amir Goldstein wrote:
>> My on-disk format change request is to re-assign a ro_compat feature
>> for IS_SNAPSHOT (currently in s_flags).
>
> OK, so in addition to:
>
> #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT =A0 =A0 0x0080
>
> You would also like:
>
> #define EXT4_FEATURE_RO_COMPAT_IS_SNAPSHOT =A0 =A0 =A00x0100
>
> which is a feature flag that the kernel will never support, since thi=
s
> is a hint that snapshot should only be mounted read-only, correct?
>

That is correct.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
