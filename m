From: Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: quota: dqio_mutex design
Date: Mon, 14 Aug 2017 11:28:37 +0800
Message-ID: <CAP9B-Q=B4B+q-x66dUabCPALpOnqMXf9=85Cq96=tkQt4fi2FQ@mail.gmail.com>
References: <10928956.Fla3vXZ7d9@panda> <20170801130242.GH4215@quack2.suse.cz>
 <20170802162552.GA30353@quack2.suse.cz> <1691224.ooLB1CWbbI@panda>
 <CAP9B-QmBKVOfmT3=5wR9_P23+r6KGW_rfzJES4Y6pkjSofvPGg@mail.gmail.com>
 <20170803143657.GB23093@quack2.suse.cz> <CAP9B-QknSSZ0wpakdiANmhNBkSA6oaa=vPC_XmwAnus1Qg+n5Q@mail.gmail.com>
 <20170808160635.GA23565@quack2.suse.cz> <3ED34739A4E85E4F894367D57617CDEFEDA3EC9B@LAX-EX-MB2.datadirect.datadirectnet.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="001a114bd3362a4af10556ae4294"
Cc: Jan Kara <jack@suse.cz>, Andrew Perepechko <anserper@yandex.ru>,
        Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Wang Shilong <wshilong@ddn.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <3ED34739A4E85E4F894367D57617CDEFEDA3EC9B@LAX-EX-MB2.datadirect.datadirectnet.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--001a114bd3362a4af10556ae4294
Content-Type: text/plain; charset="UTF-8"

sorry, format did not look fine, please use attachment.

On Mon, Aug 14, 2017 at 11:24 AM, Wang Shilong <wshilong@ddn.com> wrote:
> Hello Jan,
>
>    We have tested your patches, in generally, it helped in our case. Noticed,
> our test case is only one user with many process create/remove file.
>
>
>         4.13.0-rc3 without any patches
>         no Quota                -O quota'               -O quota, project'
>         File Creation   File Unlink     File Creation   File Unlink     File Creation   File Unlink
> 0       93,068           296,028                    86,860      285,131      85,199               189,653
> 1       79,501           280,921                    91,079      277,349                   186,279       170,982
> 2       79,932           299,750                    90,246      274,457                    133,922      191,677
> 3       80,146           297,525                    86,416      272,160                    192,354      198,869
>
>         4.13.0-rc3/w Jan Kara patch
>         no Quota                -O quota'               -O quota, project'
>         File Creation   File Unlink     File Creation   File Unlink     File Creation   File Unlink
> 0       73,057          311,217                  74,898                   286,120        81,217                 288,138  ops/per second
> 1       78,872             312,471               76,470                   277,033        77,014                 288,057
> 2       79,170             291,440               76,174              283,525     73,686            283,526
> 3       79,941             309,168            78,493              277,331          78,751            281,377
>
>         4.13.0-rc3/with https://patchwork.ozlabs.org/patch/799014/
>         no Quota                -O quota'               -O quota, project'
>         File Creation   File Unlink     File Creation   File Unlink     File Creation   File Unlink
> 0       100,319                 322,746                  87,480                  302,579                 84,569                 218,969
> 1       728,424                 299,808            312,766           293,471           219,198          199,389
> 2       729,410           300,930            315,590           289,664           218,283          197,871
> 3       727,555           298,797                316,837                 289,108           213,095          213,458
>
>         4.13.0-rc3/w https://patchwork.ozlabs.org/patch/799014/ + Jan Kara patch
>         no Quota                -O quota'               -O quota, project'
>         File Creation   File Unlink     File Creation   File Unlink     File Creation   File Unlink
> 0       100,312                  324,871                 87,076                  267,303                  86,258                288,137
> 1       707,524                  298,892           361,963           252,493            421,919         282,492
> 2       707,792            298,162           363,450           264,923            397,723       283,675
> 3       707,420            302,552               354,013                 266,638                  421,537       281,763
>
>
> In conclusion, your patches helped a lot for our testing, noticed, please ignored test0 running
> for creation, the first time testing will loaded inode cache in memory, we used test1-3 to compare.
>
> With extra patch applied, your patches improved File creation(quota+project) 2X, File unlink
> 1.5X.
>
> Thanks,
> Shilong
>
> ________________________________________
> From: Jan Kara [jack@suse.cz]
> Sent: Wednesday, August 09, 2017 0:06
> To: Wang Shilong
> Cc: Jan Kara; Andrew Perepechko; Shuichi Ihara; Wang Shilong; Li Xi; Ext4 Developers List; linux-fsdevel@vger.kernel.org
> Subject: Re: quota: dqio_mutex design
>
> Hi,
>
> On Thu 03-08-17 22:39:51, Wang Shilong wrote:
>> Please send me patches, we could test and response you!
>
> So I finally have something which isn't obviously wrong (it survives basic
> testing and gives me improvements for some workloads). I have pushed out
> the patches to:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git quota_scaling
>
> I'd be happy if you can share your results with my patches. I have not yet
> figured out a safe way to reduce the contention on dq_lock during update of
> on-disk structure when lot of processes bang single dquot. I have
> experimental patch but it didn't bring any benefit in my testing - I'll
> rebase it on top of other patches I have send it to you for some testing.
>
>                                                                 Honza
>
>> On Thu, Aug 3, 2017 at 10:36 PM, Jan Kara <jack@suse.cz> wrote:
>> > Hello!
>> >
>> > On Thu 03-08-17 19:31:04, Wang Shilong wrote:
>> >> We DDN is investigating the same issue!
>> >>
>> >> Some comments comes:
>> >>
>> >> On Thu, Aug 3, 2017 at 1:52 AM, Andrew Perepechko <anserper@yandex.ru> wrote:
>> >> >> On Tue 01-08-17 15:02:42, Jan Kara wrote:
>> >> >> > Hi Andrew,
>> >> >> >
>> >> >> I've been experimenting with this today but this idea didn't bring any
>> >> >> benefit in my testing. Was your setup with multiple users or a single user?
>> >> >> Could you give some testing to my patches to see whether they bring some
>> >> >> benefit to you?
>> >> >>
>> >> >>                                                               Honza
>> >> >
>> >> > Hi Jan!
>> >> >
>> >> > My setup was with a single user. Unfortunately, it may take some time before
>> >> > I can try a patched kernel other than RHEL6 or RHEL7 with the same test,
>> >> > we have a lot of dependencies on these kernels.
>> >> >
>> >> > The actual test we ran was mdtest.
>> >> >
>> >> > By the way, we had 15+% performance improvement in creates from the
>> >> > change that was discussed earlier in this thread:
>> >> >
>> >> >            EXT4_SB(dquot->dq_sb)->s_qf_names[GRPQUOTA]) {
>> >> > +              if (test_bit(DQ_MOD_B, &dquot->dq_flags))
>> >> > +                       return 0;
>> >>
>> >> I don't think this is right, as far as i understand, journal quota need go
>> >> together with quota space change update inside same transaction, this will
>> >> break consistency if power off or RO happen.
>> >>
>> >> Here is some ideas that i have thought:
>> >>
>> >> 1) switch dqio_mutex to a read/write lock, especially, i think most of
>> >> time journal quota updates is in-place update, that means we don't need
>> >> change quota tree in memory, firstly try read lock, retry with write lock if
>> >> there is real tree change.
>> >>
>> >> 2)another is similar idea of Andrew's walkaround, but we need make correct
>> >> fix, maintain dirty list for per transaction, and gurantee quota updates are
>> >> flushed when commit transaction, this might be complex, i am not very
>> >> familiar with JBD2 codes.
>> >>
>> >> It will be really nice if we could fix this regression, as we see 20% performace
>> >> regression.
>> >
>> > So I have couple of patches:
>> >
>> > 1) I convert dqio_mutex do rw semaphore and use it in exclusive mode only
>> > when quota tree is going to change. We also use dq_lock to serialize writes
>> > of dquot - you cannot have two writes happening in parallel as that could
>> > result in stale data being on disk. This patch brings benefit when there
>> > are multiple users - now they don't contend on common lock. It shows
>> > advantage in my testing so I plan to merge these patches. When the
>> > contention is on a structure for single user this change however doesn't
>> > bring much (the performance change is in statistical noise in my testing).
>> >
>> > 2) I have patches to remove some contention on dq_list_lock by not using
>> > dirty list for tracking dquots in ext4 (and thus avoid dq_list_lock
>> > completely in quota modification path). This does not bring measurable
>> > benefit in my testing even on ramdisk but lockstat data for dq_list_lock
>> > looks much better after this - it seems lock contention just shifted to
>> > dq_data_lock - I'll try to address that as well and see whether I'll be
>> > able to measure some advantage.
>> >
>> > 3) I have patches to convert dquot dirty bit to sequence counter so that
>> > in commit_dqblk() we can check whether dquot state we wanted to write is
>> > already on disk. Note that this is different from Andrew's approach in that
>> > we do wait for dquot to be actually written before returning. We just don't
>> > repeat the write unnecessarily. However this didn't bring any measurable
>> > benefit in my testing so unless I'll be able to confirm it benefits some
>> > workloads I won't merge this change.
>> >
>> > If you can experiment with your workloads, I can send you patches. I'd be
>> > keen on having some performance data from real setups...
>> >
>> >                                                                 Honza
>> >
>> >>
>> >> Thanks,
>> >> Shilong
>> >>
>> >> >                dquot_mark_dquot_dirty(dquot);
>> >> >                return ext4_write_dquot(dquot);
>> >> >
>> >> > The idea was that if we know that some thread is somewhere between
>> >> > mark_dirty and clear_dirty, then we can avoid blocking on dqio_mutex,
>> >> > since that thread will update the ondisk dquot for us.
>> >> >
>> > --
>> > Jan Kara <jack@suse.com>
>> > SUSE Labs, CR
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

--001a114bd3362a4af10556ae4294
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;
	name="mdtest-JK-patch.xlsx"
Content-Disposition: attachment; filename="mdtest-JK-patch.xlsx"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j6blmhug0

UEsDBBQABgAIAAAAIQA7SI5AaQEAAMQEAAATAAgCW0NvbnRlbnRfVHlwZXNdLnhtbCCiBAIooAAC
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACs
lMtOwzAQRfdI/EPkLUrcskAINe2CxxIqUT7AxJPE1C953NL+PROXVgiFVKjdxIrHc++ZkceT2cbo
bA0BlbMlGxcjloGtnFS2Kdnb4im/ZRlGYaXQzkLJtoBsNr28mCy2HjCjbIsla2P0d5xj1YIRWDgP
liK1C0ZE+g0N96Jaigb49Wh0wytnI9iYx06DTScPUIuVjtnjhrZ3JJTOsvvduc6qZMJ7rSoRCZR3
Ud6bF0DjQOLayl90+TdZQZlJHFvl8epvhw8PzS8HZbrSUoCoXqidQUnI5iLEZ2GInW80/3Rh+e7c
shgurYfQ1bWqQLpqZahrBfoAQmILEI0u0loYoeyeecA/HUaelvGZQbr6kvARjkh3BHj6no6QZI4Y
YtxqwHO3PYkec25FAPkaA03T2QF+ag9x0L2ZB+eRpi7A/7uwH48uO/ckBCEqOAxI32U7ONLIntx2
6N4ECbLHm6c3aPoFAAD//wMAUEsDBBQABgAIAAAAIQB9zFSeBwEAAN0CAAALAAgCX3JlbHMvLnJl
bHMgogQCKKAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAArJLBSsQwEIbvgu8Qct+mu4qIbLoXEfYmUh9gNpm22TaZkGS1+/ZGD2qhFME9Tmby
z/fnz3Y32oG9YYiGnOTrouQMnSJtXCv5a/20uucsJnAaBnIo+Rkj31XXV9sXHCDlS7EzPrKs4qLk
XUr+QYioOrQQC/LocqehYCHlMrTCg+qhRbEpyzsRfmvwaqLJ9lrysNc3nNVnnzf/R1tYTKAhgVAU
cOVDJgvJZC+shtBiklyTes7H8WuiyNRczAPd/h2ImsYofCR1sujSjGeBY0KnUS8jgfdLROtLEk2Z
f95nHMQ7hf5A1C+xbC4bV+pO9uDADDNBffeKo8f2My4x+ZTVBwAAAP//AwBQSwMEFAAGAAgAAAAh
AIyWxW7zAAAAugIAABoACAF4bC9fcmVscy93b3JrYm9vay54bWwucmVscyCiBAEooAABAAAAAAAA
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
hId2MV/p7gT2tZjjMcUQX4g5XkyM+GHJfAW9NSxZoyQfLYGEm29GS5aUzlf4BDPiDSX5aAm+6sw3
oyW4GEOJfkoUjp7F6IEmPyyhEepEYyOlEn3TgjvkDCXq4mmENZSo2yWUzPr5enw4veOZWrPb4vXS
a31s1Mso/b7nVL5Vfy/Pb7vjZbKvXvUrJASUs3mmFBH1jaw+qbdJKZTgc9009cH+9Y5XaxWe+kQE
J5TXum7sH2hc+f1aNd9Pk1N5qs5fd3/ijRK2eX3e4a2Tfpa2mJ7qc3Mud8108g77n+hXuV+edtiw
LBOZ+mqD9YhHeOj3sECNsHts9/h/AAAA//8DAFBLAwQKAAAAAAAAACEAOh8BwhBAAAAQQAAAFwAA
AGRvY1Byb3BzL3RodW1ibmFpbC5qcGVn/9j/4AAQSkZJRgABAQAASABIAAD/4QCARXhpZgAATU0A
KgAAAAgABAEaAAUAAAABAAAAPgEbAAUAAAABAAAARgEoAAMAAAABAAIAAIdpAAQAAAABAAAATgAA
AAAAAABIAAAAAQAAAEgAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAAAQCgAwAEAAAAAQAAAJwA
AAAA/+0AOFBob3Rvc2hvcCAzLjAAOEJJTQQEAAAAAAAAOEJJTQQlAAAAAAAQ1B2M2Y8AsgTpgAmY
7PhCfv/AABEIAJwBAAMBEQACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/
xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKC
CQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaH
iImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp
6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAME
BwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYn
KCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeY
mZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/
2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB
AQEBAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB
AQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/3QAEACD/2gAMAwEAAhEDEQA/AP7uvC/hfwzceGfDs8/h
3Qp55tC0iWaabSdPklmlk0+3eSWWR7Vnkkkcl3d2ZmYlmJJJoA3f+ES8Kf8AQseHv/BNpv8A8iUA
H/CJeFP+hY8Pf+CbTf8A5EoAP+ES8Kf9Cx4e/wDBNpv/AMiUAH/CJeFP+hY8Pf8Agm03/wCRKAD/
AIRLwp/0LHh7/wAE2m//ACJQAf8ACJeFP+hY8Pf+CbTf/kSgA/4RLwp/0LHh7/wTab/8iUAH/CJe
FP8AoWPD3/gm03/5EoAP+ES8Kf8AQseHv/BNpv8A8iUAH/CJeFP+hY8Pf+CbTf8A5EoAP+ES8Kf9
Cx4e/wDBNpv/AMiUAH/CJeFP+hY8Pf8Agm03/wCRKAD/AIRLwp/0LHh7/wAE2m//ACJQAf8ACJeF
P+hY8Pf+CbTf/kSgA/4RLwp/0LHh7/wTab/8iUAH/CJeFP8AoWPD3/gm03/5EoAP+ES8Kf8AQseH
v/BNpv8A8iUAH/CJeFP+hY8Pf+CbTf8A5EoAP+ES8Kf9Cx4e/wDBNpv/AMiUAH/CJeFP+hY8Pf8A
gm03/wCRKAD/AIRLwp/0LHh7/wAE2m//ACJQAf8ACJeFP+hY8Pf+CbTf/kSgA/4RLwp/0LHh7/wT
ab/8iUAH/CJeFP8AoWPD3/gm03/5EoAP+ES8Kf8AQseHv/BNpv8A8iUAH/CJeFP+hY8Pf+CbTf8A
5EoAP+ES8Kf9Cx4e/wDBNpv/AMiUAH/CJeFP+hY8Pf8Agm03/wCRKAD/AIRLwp/0LHh7/wAE2m//
ACJQAf8ACJeFP+hY8Pf+CbTf/kSgA/4RLwp/0LHh7/wTab/8iUAf/9D+9fwj/wAip4Y/7F7Rf/Tb
bUAdDQAUAFABQAUAFABQAUAFABQAUAFABQAUAFABQAUAFABQAUAFABQAUAFABQAUAFABQAUAFABQ
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
YXBwLnhtbFBLBQYAAAAACwALAMUCAABcagAAAAA=
--001a114bd3362a4af10556ae4294--
