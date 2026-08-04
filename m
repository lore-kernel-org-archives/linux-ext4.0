Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D55380FC1;
	Tue,  4 Aug 2026 11:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785844165; cv=none; b=b7hPcvJqYnaJqpHqLLQm1tg6DKeUiA0+Bt+VELs1zze3saLUBzJob2NmgZ2TwBzF6uoRTvRiJz/6Toi8/BnSYDAlRNQzlTdRc84SmUYFf0z7Qkex7Zb1a+rUN+KTA7KVlY5wND5kHwn7W2rfrRvjG5nVZD65RtqbM1v58pycdaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785844165; c=relaxed/simple;
	bh=OjNhjbraGWEJeJV4GV9ZU44+MZnTzFd9lFhjVxTUvQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZ2Gsvco8AF3C7saGyFCU8O0nmb6fnQkBmFrPgKKD3tB4nc2gHDmvoZv7CiFWQIwLfOjRRdKf4f/+LkylBD9bWRS+BzPBtL6oMns1elQ4zBuVlnnAtlHBlspkrfw8XxsBcDAZkIj2fULxQzq8fwMkeIy/rXTPVtXEHrtR3hdrJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aBGgAlnl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aBGgAlnl"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6748HkN8382814;
	Tue, 4 Aug 2026 11:49:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=nsb6PnTgF3ScqtOky7upFi0ohAhzUp
	oTxYtPpaBjKI0=; b=aBGgAlnlpC1vVZ8Vk+Y0BdfeZ/qgDr6miyAVemiVVBGYIF
	mxq6hkVOSqr66DKKp92VeAK2chTLKvy1SZgC/rJyhwnMo18/unn2lVehDJy3T+7u
	a6p3r/375ulAgKT6gyq2R+NCC5fH91HgaxapSi/U6CRjVXvw8bHQw7L7kS0ze8Uz
	6dYZCzhh4KJP3abrv3zCOOvVK5wQQYiSz0VwZ85GjnN8l4OjWqOKOGkwflWNR4eU
	7ZzIXnFIkVG/RKYWm50V//ACiVudn2UOwGIaB2aZFphfQrSlG7l1vMST0Z2CHgOV
	hgvThGZFkvqFAmgK5TXyLMY/pKwc5AVA1R4gbCnA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8eun6c1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Aug 2026 11:49:07 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 674BfRAe008582;
	Tue, 4 Aug 2026 11:49:06 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswtyhhj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Aug 2026 11:49:06 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 674Bn2gh27263376
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Aug 2026 11:49:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B78A820067;
	Tue,  4 Aug 2026 11:49:02 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 473CC20040;
	Tue,  4 Aug 2026 11:49:00 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  4 Aug 2026 11:49:00 +0000 (GMT)
Date: Tue, 4 Aug 2026 17:18:57 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: Venkat Rao Bagalkote <venkat88@linux.ibm.com>, linux-ext4@vger.kernel.org,
        tytso@mit.edu, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Christian Brauner <brauner@kernel.org>
Subject: Re: [BUG] ext4: NULL/invalid pointer dereference in
 ext4_writepages() during generic/039
Message-ID: <anHRqYmzo9xYQoJN@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <9ac0524e-0644-4fba-a256-c5b7fe333a3e@linux.ibm.com>
 <anA6s9L-cpsifqgU@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <anDwoVwYf8EBCm6-@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <yythlv3m2yv3ezxaw3vu3q7wasrmme4jjtjlgpck2dzx3tah5s@unp5f6beyk3w>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yythlv3m2yv3ezxaw3vu3q7wasrmme4jjtjlgpck2dzx3tah5s@unp5f6beyk3w>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: VRpl2zqqw-XCpU5AJd4qcMGe3c85DKo4
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDA5NCBTYWx0ZWRfX78oWfvmJ9cS8
 7LLPiJamRcjCOB1K48mDK6NbCPnrgyvD09si3PPfCJExcZHPxuQ/hyV2rKUep0ABTi8yDx1hrNt
 ipj9XTWL+1vqUD9kQqsaD936jCTjNJc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDA5NCBTYWx0ZWRfXyYM7/FkSfVms
 Eco0C6sCwr/XqWAZ0EBVVUNrHmlNz2SZ+Ldoj9AOjPHF5BLBz0gAIAULC7qyKjIHewZYaW7pw/E
 xn//j18BcsMHlKEwIFRguYJVhzXe8DMr3ME36ZW+AIINmI8IgXn4WhNlqYQWyWHKbplAXf/Y7ds
 w2o53fjuZqRgOZ6bGyfj/MfIpY5XsYbZg6ohb4Ha8S/uohIqSs2IIvSeX/pcIbOuDZ0uQ2CGrN4
 nBUd/UclRjtdR7vPebyDjKgel5+awB1voLNf+t9jXfJjGsubmVUSxl0EcYZKE2J3d0dV6Gr84KM
 6dIVPlrCctDrfwXr+mSMiBGpwI5BkMfjhXNq7d6fp/4zF16OX89NIr0pgHcuwKWky8e69WgOBm7
 HGk+8efUUZ52BXdIw95kqOa/Np58EbVENgDgDRiiZYe/bUaGWU8CTrjU75gDjw1cOGCq6uZ/GTB
 rL9Sqe6dbhIwd4wgq9A==
X-Proofpoint-GUID: VRpl2zqqw-XCpU5AJd4qcMGe3c85DKo4
X-Authority-Analysis: v=2.4 cv=KfzidwYD c=1 sm=1 tr=0 ts=6a71d1b3 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=iox4zFpeAAAA:8 a=tfKs4QMLRRCDZ7kKY2QA:9 a=CjuIK1q_8ugA:10
 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_02,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608040094

On Tue, Aug 04, 2026 at 12:41:09PM +0200, Jan Kara wrote:
> Hello!
> 
> On Tue 04-08-26 01:18:49, Ojaswin Mujoo wrote:
> > On Mon, Aug 03, 2026 at 12:22:35PM +0530, Ojaswin Mujoo wrote:
> ...
> > > > Meanwhile, I will attempt bisection.
> > > > 
> > > > If you happen to fix this issue, please add below tag.
> > > > 
> > > > Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> > > > 
> > > 
> > > Hey thanks for reporting this Venkat, I'll try to replicate this at my
> > > end.
> > > 
> > > In the meantime, can you please share the complete Oops message and also
> > > your local.config. 
> > > 
> > > Thanks,
> > > ojaswin
> > 
> > (+cc Jan, Christian)
> > 
> > Okay so I'm able to replicate this in an x86 machine as well with 4kb
> > block size. The issue is replicable in vfs/vfs.all and is occurring
> > after Jan's change to nojournal mode writeout [1], with fast_commit.
> > 
> > The issue is as follows:
> > 
> >   __ext4_fill_super
> >     ext4_load_and_init_journal
> >       ...
> >       jbd2_journal_recover
> >         do_one_pass
> >           fc_do_one_pass
> >             ...
> >             ext4_fc_replay_unlink
> >               __ext4_unlink
> >                 __ext4_mark_iloc_dirty
> >                   if (sbi->s_journal == NULL)  // s_journal is not set yet
> >                     set_inode_metadata_writeback(inode); // sets I_METADATA_WRITEBACK
> >               iput(inode)
> >                 iput_final(inode)
> >                   ...
> >                   writeback_single_inode
> >                     __writeback_single_inode  // since I_METADATA_WRITEBACK is set
> >                       ...
> >                       ext4_writepages
> >                         ext4_writepages_down_read
> >                           percpu_down_read(sbi->s_writepages_rwsem)
> >                              <--- OOPS because this is initialized
> >                                   later in ext4_percpu_param_init()
> > 
> > A simple fix seems to be to move ext4_percpu_param_init() call before
> > ext4_load_journal() so that we can safely call ext4_writepages(). The
> > below diff seems to be fixing the issue for me, does this look okay to
> > you Jan?
> 
> Thanks for report and the analysis! I didn't realize fastcommit replay
> actually runs in nojournal mode. I don't think moving
> ext4_percpu_param_init() is really correct - it initializes also directory,
> free blocks and other counters and those depend on filesystem already being
> in consistent state (i.e., after journal replay). We would have to move
> just s_writepages_rwsem initialization.

Hey Jan, yes right thanks for pointing that out.
> 
> That being said I think a nicer fix is to just avoid setting
> I_METADATA_WRITEBACK flag during fastcommit replay. We don't really need
> it for anything during replay (it flushes the whole bdev anyway), it just
> slows things down by more frequent buffer writeout. I've tested that change
> and it fixes the problem for me. I'll post it officially shortly.

Sure thanks!

Regards,
ojaswin

> 
> 								Honza 
> 
> > Also, venkat can you please help test this in your system:
> > 
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 2877a6cf6d09..6e05f191542c 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -5511,6 +5511,10 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
> >                         goto failed_mount3a;
> >         }
> > 
> > +       err = ext4_percpu_param_init(sbi);
> > +       if (err)
> > +               goto failed_mount3a;
> > +
> >         err = -EINVAL;
> >         /*
> >          * The first inode we look at is the journal inode.  Don't try
> > @@ -5659,10 +5663,6 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
> >                         clear_opt2(sb, MB_OPTIMIZE_SCAN);
> >         }
> > 
> > -       err = ext4_percpu_param_init(sbi);
> > -       if (err)
> > -               goto failed_mount5;
> > -
> >         err = ext4_mb_init(sb);
> >         if (err) {
> >                 ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
> > @@ -5764,7 +5764,6 @@ failed_mount8: __maybe_unused
> >         ext4_mb_release(sb);
> >         ext4_flex_groups_free(sbi);
> >  failed_mount5:
> > -       ext4_percpu_param_destroy(sbi);
> >         ext4_ext_release(sb);
> >         ext4_release_system_zone(sb);
> >  failed_mount4a:
> > @@ -5785,6 +5784,7 @@ failed_mount8: __maybe_unused
> >                 ext4_journal_destroy(sbi, sbi->s_journal);
> >         }
> >  failed_mount3a:
> > +       ext4_percpu_param_destroy(sbi);
> >         ext4_es_unregister_shrinker(sbi);
> >  failed_mount3:
> >         /* flush s_sb_upd_work before sbi destroy */
> > 
> > [1] https://lore.kernel.org/linux-ext4/20260727104923.3828017-37-jack@suse.cz/
> > > > 
> > > > 
> > > > Thanks,
> > > > Venkat.
> > > > 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
