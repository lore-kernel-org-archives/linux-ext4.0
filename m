From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH 2/8] e2fsprogs: Add big_journal feature for Next3
Date: Tue, 22 Jun 2010 12:06:38 +0300
Message-ID: <AANLkTillo6C4VwDPm4Evv9v916K9GSXueANSLFXG0p6t@mail.gmail.com>
References: <3E370776-8EA9-445D-8366-4975AD1FA57C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Amir Goldstein <amir73il@users.sf.net>,
	"linux-ext4@vger.kernel.org development" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64014 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758959Ab0FVJGk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jun 2010 05:06:40 -0400
Received: by bwz7 with SMTP id 7so1294386bwz.19
        for <linux-ext4@vger.kernel.org>; Tue, 22 Jun 2010 02:06:38 -0700 (PDT)
In-Reply-To: <3E370776-8EA9-445D-8366-4975AD1FA57C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 21, 2010 at 9:21 PM, Andreas Dilger <adilger@dilger.ca> wro=
te:
>> Next3 transactions reserve up to 24 times more credits than Ext3 tra=
nsactions for the same operation. =A0On mke2fs and tune2fs, if the 'big=
_journal' feature is set along with the 'has_journal' feature, increase=
 the default journal size by a factor of 24.
>
> It is already possible to specify an arbitrary journal size with "-J =
size=3D{MB}", so there is no need to consume a feature flag just to hin=
t what the journal size should be.
>
> It would be possible to check for some other snapshot-related feature=
 flag, like "EXCLUDE_INODE" to determine if the journal is large enough=
 for snapshotting, if it was deleted by e2fsck. =A0Otherwise, it is bes=
t to let the user specify the journal size they want.
>

Ted has already pointed out that a -J option would be more appropriate =
for this,
so I implemented the -J big option instead of the big_journal feature.

The differences between -J size=3D{MB} and -J big, are:
1. -J big is more user friendly
2. -J big chooses a size which is the best fit for the file system size

BTW, those are not the most recent patches. the latest patch series is
available at:
http://sourceforge.net/projects/next3/files/Latest%20patch%20series

If you like, I can post the latest patches to the list.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
