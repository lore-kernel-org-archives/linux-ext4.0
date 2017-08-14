From: Jan Kara <jack@suse.cz>
Subject: Re: quota: dqio_mutex design
Date: Mon, 14 Aug 2017 10:22:54 +0200
Message-ID: <20170814082254.GA16353@quack2.suse.cz>
References: <10928956.Fla3vXZ7d9@panda>
 <20170801130242.GH4215@quack2.suse.cz>
 <20170802162552.GA30353@quack2.suse.cz>
 <1691224.ooLB1CWbbI@panda>
 <CAP9B-QmBKVOfmT3=5wR9_P23+r6KGW_rfzJES4Y6pkjSofvPGg@mail.gmail.com>
 <20170803143657.GB23093@quack2.suse.cz>
 <CAP9B-QknSSZ0wpakdiANmhNBkSA6oaa=vPC_XmwAnus1Qg+n5Q@mail.gmail.com>
 <20170808160635.GA23565@quack2.suse.cz>
 <3ED34739A4E85E4F894367D57617CDEFEDA3EC9B@LAX-EX-MB2.datadirect.datadirectnet.com>
 <CAP9B-Qkd+nq6PSOEfu9p5W2U182EwsBjuWxZ+t9XT5PQ-VGozg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Wang Shilong <wshilong@ddn.com>, Jan Kara <jack@suse.cz>,
        Andrew Perepechko <anserper@yandex.ru>,
        Shuichi Ihara <sihara@ddn.com>, Li Xi <lixi@ddn.com>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39093 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751471AbdHNIW5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 14 Aug 2017 04:22:57 -0400
Content-Disposition: inline
In-Reply-To: <CAP9B-Qkd+nq6PSOEfu9p5W2U182EwsBjuWxZ+t9XT5PQ-VGozg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On Mon 14-08-17 11:53:37, Wang Shilong wrote:
> Txt format attched.
> 
> BTW, Jan, it will be cool if you could point which patch help a lot for
> our test case, since there are a lot of patches there, we want to port
> some of patches to RHEL7.

Thanks for the test results! They are really interesting. Do you have any
explanation why without any patches the '-O quota,project' runs for 'File
Creation' are faster than runs without quota or any other runs in the test?

WRT which patches helped I don't have a good subset for you. In my testing
each patch helped a bit. I expect in your setup the conversion of dqio_sem
to rwsem and then to use dq_lock might not have that big impact. So you
might try backporting patches from "quota: Fix possible corruption of
dqi_flags" onward.

								Honza

> On Mon, Aug 14, 2017 at 11:24 AM, Wang Shilong <wshilong@ddn.com> wrote:
> > Hello Jan,
> >
> >    We have tested your patches, in generally, it helped in our case. Noticed,
> > our test case is only one user with many process create/remove file.
> >
> >
> >         4.13.0-rc3 without any patches
> >         no Quota                -O quota'               -O quota, project'
> >         File Creation   File Unlink     File Creation   File Unlink     File Creation   File Unlink
> > 0       93,068           296,028                    86,860      285,131                    85,199               189,653
> > 1       79,501           280,921                    91,079      277,349                   186,279       170,982
> > 2       79,932           299,750                    90,246      274,457                    133,922      191,677
> > 3       80,146           297,525                    86,416      272,160                    192,354      198,869
> >
> >         4.13.0-rc3/w Jan Kara patch
> >         no Quota                -O quota'               -O quota, project'
> >         File Creation   File Unlink     File Creation   File Unlink     File Creation   File Unlink
> > 0       73,057          311,217                  74,898                   286,120        81,217                 288,138  ops/per second
> > 1       78,872             312,471               76,470                   277,033        77,014                 288,057
> > 2       79,170             291,440               76,174              283,525     73,686            283,526
> > 3       79,941             309,168            78,493              277,331          78,751            281,377
> >
> >         4.13.0-rc3/with https://patchwork.ozlabs.org/patch/799014/
> >         no Quota                -O quota'               -O quota, project'
> >         File Creation   File Unlink     File Creation   File Unlink     File Creation   File Unlink
> > 0       100,319                 322,746                  87,480                  302,579                 84,569                 218,969
> > 1       728,424                 299,808            312,766           293,471           219,198          199,389
> > 2       729,410           300,930            315,590           289,664           218,283          197,871
> > 3       727,555           298,797                316,837                 289,108           213,095          213,458
> >
> >         4.13.0-rc3/w https://patchwork.ozlabs.org/patch/799014/ + Jan Kara patch
> >         no Quota                -O quota'               -O quota, project'
> >         File Creation   File Unlink     File Creation   File Unlink     File Creation   File Unlink
> > 0       100,312                  324,871                 87,076                  267,303                  86,258                288,137
> > 1       707,524                  298,892           361,963           252,493            421,919         282,492
> > 2       707,792            298,162           363,450           264,923            397,723       283,675
> > 3       707,420            302,552               354,013                 266,638                  421,537       281,763
> >
> >
> > In conclusion, your patches helped a lot for our testing, noticed, please ignored test0 running
> > for creation, the first time testing will loaded inode cache in memory, we used test1-3 to compare.
> >
> > With extra patch applied, your patches improved File creation(quota+project) 2X, File unlink
> > 1.5X.
> >
> > Thanks,
> > Shilong
> >
> > ________________________________________
> > From: Jan Kara [jack@suse.cz]
> > Sent: Wednesday, August 09, 2017 0:06
> > To: Wang Shilong
> > Cc: Jan Kara; Andrew Perepechko; Shuichi Ihara; Wang Shilong; Li Xi; Ext4 Developers List; linux-fsdevel@vger.kernel.org
> > Subject: Re: quota: dqio_mutex design
> >
> > Hi,
> >
> > On Thu 03-08-17 22:39:51, Wang Shilong wrote:
> >> Please send me patches, we could test and response you!
> >
> > So I finally have something which isn't obviously wrong (it survives basic
> > testing and gives me improvements for some workloads). I have pushed out
> > the patches to:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git quota_scaling
> >
> > I'd be happy if you can share your results with my patches. I have not yet
> > figured out a safe way to reduce the contention on dq_lock during update of
> > on-disk structure when lot of processes bang single dquot. I have
> > experimental patch but it didn't bring any benefit in my testing - I'll
> > rebase it on top of other patches I have send it to you for some testing.
> >
> >                                                                 Honza
> >
> >> On Thu, Aug 3, 2017 at 10:36 PM, Jan Kara <jack@suse.cz> wrote:
> >> > Hello!
> >> >
> >> > On Thu 03-08-17 19:31:04, Wang Shilong wrote:
> >> >> We DDN is investigating the same issue!
> >> >>
> >> >> Some comments comes:
> >> >>
> >> >> On Thu, Aug 3, 2017 at 1:52 AM, Andrew Perepechko <anserper@yandex.ru> wrote:
> >> >> >> On Tue 01-08-17 15:02:42, Jan Kara wrote:
> >> >> >> > Hi Andrew,
> >> >> >> >
> >> >> >> I've been experimenting with this today but this idea didn't bring any
> >> >> >> benefit in my testing. Was your setup with multiple users or a single user?
> >> >> >> Could you give some testing to my patches to see whether they bring some
> >> >> >> benefit to you?
> >> >> >>
> >> >> >>                                                               Honza
> >> >> >
> >> >> > Hi Jan!
> >> >> >
> >> >> > My setup was with a single user. Unfortunately, it may take some time before
> >> >> > I can try a patched kernel other than RHEL6 or RHEL7 with the same test,
> >> >> > we have a lot of dependencies on these kernels.
> >> >> >
> >> >> > The actual test we ran was mdtest.
> >> >> >
> >> >> > By the way, we had 15+% performance improvement in creates from the
> >> >> > change that was discussed earlier in this thread:
> >> >> >
> >> >> >            EXT4_SB(dquot->dq_sb)->s_qf_names[GRPQUOTA]) {
> >> >> > +              if (test_bit(DQ_MOD_B, &dquot->dq_flags))
> >> >> > +                       return 0;
> >> >>
> >> >> I don't think this is right, as far as i understand, journal quota need go
> >> >> together with quota space change update inside same transaction, this will
> >> >> break consistency if power off or RO happen.
> >> >>
> >> >> Here is some ideas that i have thought:
> >> >>
> >> >> 1) switch dqio_mutex to a read/write lock, especially, i think most of
> >> >> time journal quota updates is in-place update, that means we don't need
> >> >> change quota tree in memory, firstly try read lock, retry with write lock if
> >> >> there is real tree change.
> >> >>
> >> >> 2)another is similar idea of Andrew's walkaround, but we need make correct
> >> >> fix, maintain dirty list for per transaction, and gurantee quota updates are
> >> >> flushed when commit transaction, this might be complex, i am not very
> >> >> familiar with JBD2 codes.
> >> >>
> >> >> It will be really nice if we could fix this regression, as we see 20% performace
> >> >> regression.
> >> >
> >> > So I have couple of patches:
> >> >
> >> > 1) I convert dqio_mutex do rw semaphore and use it in exclusive mode only
> >> > when quota tree is going to change. We also use dq_lock to serialize writes
> >> > of dquot - you cannot have two writes happening in parallel as that could
> >> > result in stale data being on disk. This patch brings benefit when there
> >> > are multiple users - now they don't contend on common lock. It shows
> >> > advantage in my testing so I plan to merge these patches. When the
> >> > contention is on a structure for single user this change however doesn't
> >> > bring much (the performance change is in statistical noise in my testing).
> >> >
> >> > 2) I have patches to remove some contention on dq_list_lock by not using
> >> > dirty list for tracking dquots in ext4 (and thus avoid dq_list_lock
> >> > completely in quota modification path). This does not bring measurable
> >> > benefit in my testing even on ramdisk but lockstat data for dq_list_lock
> >> > looks much better after this - it seems lock contention just shifted to
> >> > dq_data_lock - I'll try to address that as well and see whether I'll be
> >> > able to measure some advantage.
> >> >
> >> > 3) I have patches to convert dquot dirty bit to sequence counter so that
> >> > in commit_dqblk() we can check whether dquot state we wanted to write is
> >> > already on disk. Note that this is different from Andrew's approach in that
> >> > we do wait for dquot to be actually written before returning. We just don't
> >> > repeat the write unnecessarily. However this didn't bring any measurable
> >> > benefit in my testing so unless I'll be able to confirm it benefits some
> >> > workloads I won't merge this change.
> >> >
> >> > If you can experiment with your workloads, I can send you patches. I'd be
> >> > keen on having some performance data from real setups...
> >> >
> >> >                                                                 Honza
> >> >
> >> >>
> >> >> Thanks,
> >> >> Shilong
> >> >>
> >> >> >                dquot_mark_dquot_dirty(dquot);
> >> >> >                return ext4_write_dquot(dquot);
> >> >> >
> >> >> > The idea was that if we know that some thread is somewhere between
> >> >> > mark_dirty and clear_dirty, then we can avoid blocking on dqio_mutex,
> >> >> > since that thread will update the ondisk dquot for us.
> >> >> >
> >> > --
> >> > Jan Kara <jack@suse.com>
> >> > SUSE Labs, CR
> > --
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR

> 4.13.0-rc3 without any patches
>         no Quota            -O quota         -O quota,project
>     creation   unlink    creation   unlink    creation  unlink
> 0   93,068  296,028      86,860  285,131      85,199    189,653     ops/per second
> 1   79,501  280,921      91,079  277,349     186,279    170,982
> 2   79,932  299,750      90,246  274,457     133,922    191,677
> 3   80,146  297,525      86,416  272,160     192,354    198,869
> 
> Jan Kara branch (quota_scaling)
>         no Quota            -O quota         -O quota,project
>   creation   unlink      creation   unlink    creation  unlink
> 0   73,057  311,217      74,898  286,120      81,217    288,138
> 1   78,872  312,471      76,470  277,033      77,014    288,057
> 2   79,170  291,440      76,174  283,525      73,686    283,526
> 3   79,941  309,168      78,493  277,331      78,751    281,377
> 
> 4.13.0-rc3 with v5 patch https://patchwork.ozlabs.org/patch/799014/					
>         no Quota            -O quota         -O quota,project
>   creation   unlink     creation   unlink    creation   unlink
> 0  100,319  322,746     87,480   302,579      84,569    218,969
> 1  728,424  299,808     312,766  293,471     219,198    199,389
> 2  729,410  300,930     315,590  289,664     218,283    197,871
> 3  727,555  298,797     316,837  289,108     213,095    213,458
> 
> Jan Kara branch (quota_scaling) with v5 patch https://patchwork.ozlabs.org/patch/799014/
>         no Quota            -O quota         -O quota,project
>   creation   unlink    creation   unlink    creation     unlink
> 0  100,312  324,871      87,076  267,303      86,258    288,137
> 1  707,524  298,892     361,963  252,493     421,919    282,492
> 2  707,792  298,162     363,450  264,923     397,723    283,675
> 3  707,420  302,552     354,013  266,638     421,537    281,763

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
