From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: Richacl and ext4 vs. xfs
Date: Sat, 5 Nov 2016 00:15:02 +0100
Message-ID: <CAHc6FU61GUUbMB1tuYC-knTnJL5-Le7yuR17zgfSXnns53YDow@mail.gmail.com>
References: <CAH2r5msxM2spe2vH-mvrL-8MbYaaiAaQFU=Jhy_53NCLb079xQ@mail.gmail.com>
 <D3B85625-6E65-42A4-9935-17D5C9D65414@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <smfrench@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:35789 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751321AbcKDXPD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Nov 2016 19:15:03 -0400
Received: by mail-ua0-f179.google.com with SMTP id 12so78722333uas.2
        for <linux-ext4@vger.kernel.org>; Fri, 04 Nov 2016 16:15:03 -0700 (PDT)
In-Reply-To: <D3B85625-6E65-42A4-9935-17D5C9D65414@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 4, 2016 at 11:48 PM, Andreas Dilger <adilger@dilger.ca> wrote:
> [added linux-ext4 to CC list]
>
> On Nov 4, 2016, at 1:19 PM, Steve French <smfrench@gmail.com> wrote:
>>
>> Andreas,
>> I had been working on getting some VMs together to experiment with a
>> few different Richacl configurations and it looks like the e2fsprogs
>> git hub repo with richacl enhanced ext4 utilities may need to be
>> updated or have an incompatibility with current kernels (See e2fsprogs
>> github link at http://www.bestbits.at/richacl/ ).  XFS worked ok.
>>
>> Fedora 24 Workstation, created two extra disks
>> /dev/sdb for xfs
>> /dev/sdc for ext4
>>
>> Built and installed Andreas's 4.9.0-rc1 based kernel richacl branch
>> and the other repos (xfsprogs, richacl etc.).    Had no problem
>> formatting and using /dev/sdb1 as xfs, but once I installed e2fsprogs
>> from Andreas's tree I couldn't boot the system (removed e2fsprogs and
>> the ext4 partition and booted fine).  With Andreas's e2fsprogs I
>> couldn't boot 4.9.0-rc1
>
> What version of e2fsprogs is (the other) Andreas' tree based on?  The
> newer e2fsprogs-1.43 has support for metadata checksums, but this should
> be off by default in the released version.  The testing version had it
> enabled by default.

The richacl patches were based on v1.42.12+. They only define a new
"richacl" feature flag, so I don't think they are to blame for the
failure Steve is seeing. I've still rebased the patches onto v1.43.3+
now.

Steve, I assume that /dev/sdc is not the root filesystem or listed in
/etc/fstab; if so, then the device will have no influence on booting.

Does the richacl kernel use an initrd? If so, then please check for
mkinitrd errors: I've seen versions of mkinitrd (dracut) that use a
blkid option that isn't part of e2fsprogs v1.42. Not sure if v1.43 has
this fixed or if this is a distro specific problem.

Thanks,
Andreas
