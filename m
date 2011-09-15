From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] libext2fs: reserve exclude bitmap fields in group descriptor
Date: Thu, 15 Sep 2011 16:47:17 +0300
Message-ID: <CAOQ4uxi0Xq89Va_ttTGJGZO342Mpa7HG03DhjhEsfHsubeso7A@mail.gmail.com>
References: <CAOQ4uxjydz_6Upm5AUErHct2J0VKSN3-d-XT+Jn=q9BJFWQtaw@mail.gmail.com>
	<20110915131606.GG15782@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43833 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933879Ab1IONrS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 09:47:18 -0400
Received: by yxm8 with SMTP id 8so2160513yxm.19
        for <linux-ext4@vger.kernel.org>; Thu, 15 Sep 2011 06:47:17 -0700 (PDT)
In-Reply-To: <20110915131606.GG15782@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 4:16 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Thu, Sep 15, 2011 at 09:50:20AM +0300, Amir Goldstein wrote:
>> -#define EXT2_FEATURE_COMPAT_EXCLUDE_INODE =A0 =A0 =A00x0080
>> +/* #define EXT2_FEATURE_COMPAT_EXCLUDE_INODE =A0 0x0080 not used */
>> +#define EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP =A0 =A0 0x0100
>
> Why this change? =A0Is it because you're already using 0x0100 in
> shipping systems?
>

I am using 0x80 in shipping systems and it signifies something a bit
different then
the proposed 0x100.

EXCLUDE_INODE means that special inode 9 is used to reference exclude
bitmap blocks.
EXCLUDE_BITMAP means that exclude bitmap blocks are referenced from
group descriptors.
With this distinction it will be easier for me to make the migration.

Thanks,
Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
