Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D98835B659;
	Mon, 13 Apr 2026 12:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776085129; cv=pass; b=sZ6STDBauFdm2QNjv1LN/zZ5FeukeUqSfeh1X1M5gRjLl1fYgvH9yD7CcmipQTqmxgfZxi5bSCvZEoj9/5/cRsyPCoW5wovd8uWzqe1rRePO+j19qs2juUjkRsOg7p2tmf7Pa8J5z0sI4e3p+klvv7BRpYPNsV4jbJgqxkz4kUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776085129; c=relaxed/simple;
	bh=cXdkLXwq7Xwzvgz37Nv3CF3yfZGhaoPAQ/lX82GVBoE=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=tR2NcK6heCqDy/J6dLsbda50zgyodrzW678Am043g9IYCwEUiSxK8MoNcBZxHg6GaOXggsARUTjxFplP+YcxmqJevH9GD2Y49PGuUeUsqzM98GAd/bqGVmH5DchUfqr7lGHwjV+1uyhFjHLVMbSxB0KfwPxTxMUYAbJzxiT5PL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=KuvYusmn; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="KuvYusmn"
ARC-Seal: i=1; a=rsa-sha256; t=1776085102; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=EahS+tTmOMhjHbCFylZeg8F4L/JY36UK1o4kXT92fLJkWv3wVtJJhYvq7LVH9WnXw+PooVI1bABe7zUJoep6vatPlnGBOVfGtuXsuuwLQ2CymrdWDEMYv1AuEJ8wlPVRP3TS3c5Ef3RJHzI2Xz6UMqBe+Evw4ZRVoro2+YUwjAw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1776085102; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=HrbHs38rBBU+0LG97kiTuX3QSRvWfEGGGf9SzO2HNr8=; 
	b=bokMICCH17SFPFG/eYFkmL9sTfUKwaPX7Gpt56nPqhIwaTS0bbda7VxglCe7JKHsW4f2iA6UK1RT+xwCMnX3UTspKpJkJ6b5+eJ3I9lejrRX9c2PCf8Bq/rth2g+GYCIyApp7M1/7I/XFRd/ssjy6FE+U0unZ3vwndbyM/hmqTw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1776085102;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=HrbHs38rBBU+0LG97kiTuX3QSRvWfEGGGf9SzO2HNr8=;
	b=KuvYusmnvMWHG2CK9ks0zzE64smUUTSZRoX9TqZmDfrv3FLGI8W/jjMejLgFCKQj
	PleDfRdzHBjaiH1BWqebnTsumvsw6i60RI+NWAvGOoWDiLd0oov7eitZv5VSW0yoZB+
	snAPiyY8QzwUbZFSufQ4UxZ7TEl+JvniP+5PIlnQ=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1776085096273431.4644491260433; Mon, 13 Apr 2026 05:58:16 -0700 (PDT)
Date: Mon, 13 Apr 2026 20:58:16 +0800
From: Li Chen <me@linux.beauty>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Zhang Yi" <yi.zhang@huaweicloud.com>, "Theodore Ts'o" <tytso@mit.edu>,
	"Andreas Dilger" <adilger.kernel@dilger.ca>,
	"Baokun Li" <libaokun@linux.alibaba.com>, "Jan Kara" <jack@suse.cz>,
	"Ojaswin Mujoo" <ojaswin@linux.ibm.com>,
	"Ritesh Harjani" <ritesh.list@gmail.com>,
	"Zhang Yi" <yi.zhang@huawei.com>,
	"Masami Hiramatsu" <mhiramat@kernel.org>,
	"Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
	"linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-trace-kernel" <linux-trace-kernel@vger.kernel.org>
Message-ID: <19d86ebd732.2bd14e621132527.1624681536327289755@linux.beauty>
In-Reply-To: <20260408160405.45a5ee09@gandalf.local.home>
References: <20260408112020.716706-1-me@linux.beauty>
	<20260408112020.716706-7-me@linux.beauty> <20260408160405.45a5ee09@gandalf.local.home>
Subject: Re: [RFC v6 6/7] ext4: fast commit: add lock_updates tracepoint
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi Steven,

 ---- On Thu, 09 Apr 2026 04:02:56 +0800  Steven Rostedt <rostedt@goodmis.o=
rg> wrote ---=20
 > On Wed,  8 Apr 2026 19:20:17 +0800
 > Li Chen <me@linux.beauty> wrote:
 >=20
 > > Commit-time fast commit snapshots run under jbd2_journal_lock_updates(=
),
 > > so it is useful to quantify the time spent with updates locked and to
 > > understand why snapshotting can fail.
 > >=20
 > > Add a new tracepoint, ext4_fc_lock_updates, reporting the time spent i=
n
 > > the updates-locked window along with the number of snapshotted inodes
 > > and ranges. Record the first snapshot failure reason in a stable snap_=
err
 > > field for tooling.
 > >=20
 >=20
 > [..]
 >=20
 > > @@ -1338,13 +1375,13 @@ static int ext4_fc_perform_commit(journal_t *j=
ournal)
 > >      if (ret)
 > >          return ret;
 > > =20
 > > -
 > >      ret =3D ext4_fc_alloc_snapshot_inodes(sb, &inodes, &inodes_size);
 > >      if (ret)
 > >          return ret;
 > > =20
 > >      /* Step 4: Mark all inodes as being committed. */
 > >      jbd2_journal_lock_updates(journal);
 > > +    lock_start =3D ktime_get();
 >=20
 > ktime_get() is rather quick but if you care about micro-optimizations, y=
ou
 > could have:
 >=20
 >     if (trace_ext4_fc_lock_updates_enabled())
 >         lock_start =3D ktime_get();
 >     else   =20
 >         lock_start =3D 0;
 >=20
 > >      /*
 > >       * The journal is now locked. No more handles can start and all t=
he
 > >       * previous handles are now drained. Snapshotting happens in this
 > > @@ -1358,8 +1395,15 @@ static int ext4_fc_perform_commit(journal_t *jo=
urnal)
 > >      }
 > >      ext4_fc_unlock(sb, alloc_ctx);
 > > =20
 > > -    ret =3D ext4_fc_snapshot_inodes(journal, inodes, inodes_size);
 > > +    ret =3D ext4_fc_snapshot_inodes(journal, inodes, inodes_size,
 > > +                      &snap_inodes, &snap_ranges, &snap_err);
 > >      jbd2_journal_unlock_updates(journal);
 > > +    if (trace_ext4_fc_lock_updates_enabled()) {
 >=20
 >     if (trace_ext4_fc_lock_updates_enabled() && lock_start) {
 >=20
 > But feel free to ignore this if the overhead of always calling ktime_get=
()
 > is not an issue.
 >=20
 >=20
 > > +        locked_ns =3D ktime_to_ns(ktime_sub(ktime_get(), lock_start))=
;
 > > +        trace_ext4_fc_lock_updates(sb, commit_tid, locked_ns,
 > > +                       snap_inodes, snap_ranges, ret,
 > > +                       snap_err);
 > > +    }
 > >      kvfree(inodes);
 > >      if (ret)
 > >          return ret;
 > > @@ -1564,7 +1608,7 @@ int ext4_fc_commit(journal_t *journal, tid_t com=
mit_tid)
 > >          journal_ioprio =3D EXT4_DEF_JOURNAL_IOPRIO;
 > >      set_task_ioprio(current, journal_ioprio);
 > >      fc_bufs_before =3D (sbi->s_fc_bytes + bsize - 1) / bsize;
 > > -    ret =3D ext4_fc_perform_commit(journal);
 > > +    ret =3D ext4_fc_perform_commit(journal, commit_tid);
 > >      if (ret < 0) {
 > >          if (ret =3D=3D -EAGAIN || ret =3D=3D -E2BIG || ret =3D=3D -EC=
ANCELED)
 > >              status =3D EXT4_FC_STATUS_INELIGIBLE;
 > > diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
 > > index f493642cf121..7028a28316fa 100644
 > > --- a/include/trace/events/ext4.h
 > > +++ b/include/trace/events/ext4.h
 > > @@ -107,6 +107,26 @@ TRACE_DEFINE_ENUM(EXT4_FC_REASON_VERITY);
 > >  TRACE_DEFINE_ENUM(EXT4_FC_REASON_MOVE_EXT);
 > >  TRACE_DEFINE_ENUM(EXT4_FC_REASON_MAX);
 > > =20
 > > +#undef EM
 > > +#undef EMe
 > > +#define EM(a)    TRACE_DEFINE_ENUM(EXT4_FC_SNAP_ERR_##a);
 > > +#define EMe(a)    TRACE_DEFINE_ENUM(EXT4_FC_SNAP_ERR_##a);
 > > +
 > > +#define TRACE_SNAP_ERR                        \
 > > +    EM(NONE)                        \
 > > +    EM(ES_MISS)                        \
 > > +    EM(ES_DELAYED)                        \
 > > +    EM(ES_OTHER)                        \
 > > +    EM(INODES_CAP)                        \
 > > +    EM(RANGES_CAP)                        \
 > > +    EM(NOMEM)                        \
 > > +    EMe(INODE_LOC)
 > > +
 > > +TRACE_SNAP_ERR
 > > +
 > > +#undef EM
 > > +#undef EMe
 > > +
 > >  #define show_fc_reason(reason)                        \
 > >      __print_symbolic(reason,                    \
 > >          { EXT4_FC_REASON_XATTR,        "XATTR"},        \
 > > @@ -2818,6 +2838,47 @@ TRACE_EVENT(ext4_fc_commit_stop,
 > >            __entry->num_fc_ineligible, __entry->nblks_agg, __entry->ti=
d)
 > >  );
 > > =20
 > > +#define EM(a)    { EXT4_FC_SNAP_ERR_##a, #a },
 > > +#define EMe(a)    { EXT4_FC_SNAP_ERR_##a, #a }
 > > +
 > > +TRACE_EVENT(ext4_fc_lock_updates,
 > > +        TP_PROTO(struct super_block *sb, tid_t commit_tid, u64 locked=
_ns,
 > > +             unsigned int nr_inodes, unsigned int nr_ranges, int err,
 > > +             int snap_err),
 > > +
 > > +    TP_ARGS(sb, commit_tid, locked_ns, nr_inodes, nr_ranges, err, sna=
p_err),
 > > +
 > > +    TP_STRUCT__entry(/* entry */
 > > +        __field(dev_t, dev)
 > > +        __field(tid_t, tid)
 > > +        __field(u64, locked_ns)
 > > +        __field(unsigned int, nr_inodes)
 > > +        __field(unsigned int, nr_ranges)
 > > +        __field(int, err)
 > > +        __field(int, snap_err)
 > > +    ),
 > > +
 > > +    TP_fast_assign(/* assign */
 > > +        __entry->dev =3D sb->s_dev;
 > > +        __entry->tid =3D commit_tid;
 > > +        __entry->locked_ns =3D locked_ns;
 > > +        __entry->nr_inodes =3D nr_inodes;
 > > +        __entry->nr_ranges =3D nr_ranges;
 > > +        __entry->err =3D err;
 > > +        __entry->snap_err =3D snap_err;
 > > +    ),
 > > +
 > > +    TP_printk("dev %d,%d tid %u locked_ns %llu nr_inodes %u nr_ranges=
 %u err %d snap_err %s",
 > > +          MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
 > > +          __entry->locked_ns, __entry->nr_inodes, __entry->nr_ranges,
 > > +          __entry->err, __print_symbolic(__entry->snap_err,
 > > +                         TRACE_SNAP_ERR))
 > > +);
 > > +
 > > +#undef EM
 > > +#undef EMe
 > > +#undef TRACE_SNAP_ERR
 > > +
 > >  #define FC_REASON_NAME_STAT(reason)                    \
 > >      show_fc_reason(reason),                        \
 > >      __entry->fc_ineligible_rc[reason]
 >=20
 > As for the rest:
 >=20
 > Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
 >=20
 > [ Please add this reviewed-by to any new versions so I remember I alread=
y
 >   looked at it. ]

Sure, thanks a lot for your thoughtful review!

Regards,
Li=E2=80=8B

