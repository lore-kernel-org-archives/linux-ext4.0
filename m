From: Steve French <smfrench@gmail.com>
Subject: Re: Richacl and ext4 vs. xfs
Date: Mon, 7 Nov 2016 13:50:25 -0600
Message-ID: <CAH2r5ms2htCY8yioJcoKB65t32x+xSZqvKPQd0yb_yKZKrwkHA@mail.gmail.com>
References: <CAH2r5msxM2spe2vH-mvrL-8MbYaaiAaQFU=Jhy_53NCLb079xQ@mail.gmail.com>
 <D3B85625-6E65-42A4-9935-17D5C9D65414@dilger.ca> <CAHc6FU61GUUbMB1tuYC-knTnJL5-Le7yuR17zgfSXnns53YDow@mail.gmail.com>
 <CAH2r5mtFMcfhsB1OP+2ayk6gpvZkNLMtGWN7rNoGvLFayERLmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andreas Dilger <adilger@dilger.ca>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5mtFMcfhsB1OP+2ayk6gpvZkNLMtGWN7rNoGvLFayERLmw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Nov 6, 2016 at 6:31 PM, Steve French <smfrench@gmail.com> wrote:
> On Fri, Nov 4, 2016 at 4:15 PM, Andreas Gruenbacher <agruenba@redhat.com> wrote:
>> On Fri, Nov 4, 2016 at 11:48 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>>> [added linux-ext4 to CC list]
>>>
>>> On Nov 4, 2016, at 1:19 PM, Steve French <smfrench@gmail.com> wrote:
>>>>
>>>> Andreas,
>>>> I had been working on getting some VMs together to experiment with a
>>>> few different Richacl configurations and it looks like the e2fsprogs
>>>> git hub repo with richacl enhanced ext4 utilities may need to be
>>>> updated or have an incompatibility with current kernels (See e2fsprogs
>>>> github link at http://www.bestbits.at/richacl/ ).  XFS worked ok.
>>>>
>>>> Fedora 24 Workstation, created two extra disks
>>>> /dev/sdb for xfs
>>>> /dev/sdc for ext4
>>>>
>>>> Built and installed Andreas's 4.9.0-rc1 based kernel richacl branch
>>>> and the other repos (xfsprogs, richacl etc.).    Had no problem
>>>> formatting and using /dev/sdb1 as xfs, but once I installed e2fsprogs
>>>> from Andreas's tree I couldn't boot the system (removed e2fsprogs and
>>>> the ext4 partition and booted fine).  With Andreas's e2fsprogs I
>>>> couldn't boot 4.9.0-rc1
>>>
>>> What version of e2fsprogs is (the other) Andreas' tree based on?  The
>>> newer e2fsprogs-1.43 has support for metadata checksums, but this should
>>> be off by default in the released version.  The testing version had it
>>> enabled by default.
>>
>> The richacl patches were based on v1.42.12+. They only define a new
>> "richacl" feature flag, so I don't think they are to blame for the
>> failure Steve is seeing. I've still rebased the patches onto v1.43.3+
>> now.
>>
>> Steve, I assume that /dev/sdc is not the root filesystem or listed in
>> /etc/fstab; if so, then the device will have no influence on booting.
> /dev/sdc should have no impact on booting (it was empty)
>
> /dev/sda1 was /boot and ext4
> /dev/sda2 was /
> /dev/sdb1 was xfs formatted with richacl and his xfsprogs (mounted a /xfs)
> installing e2fsprogs and formatting /dev/sdc1 (mounted as /ext4) was
> ok until the reboot when it
>
>
>> Does the richacl kernel use an initrd? If so, then please check for
>> mkinitrd errors: I've seen versions of mkinitrd (dracut) that use a
>> blkid option that isn't part of e2fsprogs v1.42. Not sure if v1.43 has
>> this fixed or if this is a distro specific problem.

grub2/grub.cfg specifies initrd16 /initramfs-4.9.0-rc1+.img

It worked fine when I installed your git tree with the newer e2fsprogs

-- 
Thanks,

Steve
