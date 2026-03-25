Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F0327453;
	Wed, 25 Mar 2026 06:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774419433; cv=pass; b=h/gbq/Omkxfigv9eVuvA2pJp7mRTjo3L5hLxVHmbRE2US6ERx0jyWWY909hLVQttALlBBTEbgHNHQV3W7k79Td3trSrJQJYsXqYRIa8LgGd7KndVu66niX1CpGAI4SQLXlPIRRHc25iXEGsWEZBJbn+k68aJuYnRoK4ZjUGqIuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774419433; c=relaxed/simple;
	bh=fMgcaVu+9YkIHzMRkix9WHnVzSQ0fglslUoLUzlKwGg=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=W5l93kselq4KCpSHxNsTUe/vkI/vRfbuDmYeO4R4PceMwuk2W0XL4qY5FSRs3vNsEk1nDF6yzffkVVpLQFjISHdE2uoXrKB1wIooI2o7H/hWCcses+98KwOujM8+L9qEKgmmG+oHFGtmYWk4swY9ORGxoVmhLciaTpul6OjtYc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=cHIgIZvw; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="cHIgIZvw"
ARC-Seal: i=1; a=rsa-sha256; t=1774419422; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=P9RncUrfSgufWo8IGMxEcIq6SUx9ROOIHu3mzOjH27FyywJp1OeTtNE72697RUIxgvv9EbQUsRJxDgMDwiS0cen6734xKg4GqFwZ7Y5akPoHRohpa9WQVzQbDEuZU7x0UG7wBHlhJo0crs2rGbqOrA9JPmrppKQemXfXGMdzB0Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1774419422; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=qhYG/KQSKxIEDR8YxQvocaPx3rUqa1Z8m8txWwCW8Vs=; 
	b=Rp/yRSUZkaQPRefiLGPT9TQYTLTUWh3RowBpGKj0E3wJIA5HVctnzD5QWdRjU/lbr9cqqT3iXIsy1bdQlEbu5jgtuf7MJ7M9ikZfWU2FKhDE2fTh8kqxhhibwPYc88boObdGckfS0pCWYKx4Abj6qvxA8erKxTBEX9SViqMa3S8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774419422;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=qhYG/KQSKxIEDR8YxQvocaPx3rUqa1Z8m8txWwCW8Vs=;
	b=cHIgIZvwkTjNMKDRIfhf/iB8ZYkPESpuYJAoZA1UR3XneR3XeF3xbGsg8bFCRXp1
	e3qHxQ1mQHWkFIrD3eiPrGkGhuLeJBp8tS5QTfRyY6yGYYQOLBvNzsW2dMtrdBi2o5k
	D2+6WHk4RuNVesm1YpmtYEOP525uj3CZAP5ngY7s=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1774419419230354.88223286998016; Tue, 24 Mar 2026 23:16:59 -0700 (PDT)
Date: Wed, 25 Mar 2026 14:16:59 +0800
From: Li Chen <me@linux.beauty>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Zhang Yi" <yi.zhang@huaweicloud.com>, "Theodore Ts'o" <tytso@mit.edu>,
	"Andreas Dilger" <adilger.kernel@dilger.ca>,
	"Masami Hiramatsu" <mhiramat@kernel.org>,
	"Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
	"linux-ext4" <linux-ext4@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-trace-kernel" <linux-trace-kernel@vger.kernel.org>,
	"Vineeth Remanan Pillai" <vineeth@bitbyteword.org>
Message-ID: <19d23a3a04c.34309de42984481.2847144293854414800@linux.beauty>
In-Reply-To: <20260317122149.5d07132a@gandalf.local.home>
References: <20260317084624.457185-1-me@linux.beauty>
	<20260317084624.457185-7-me@linux.beauty> <20260317122149.5d07132a@gandalf.local.home>
Subject: Re: [RFC v5 6/7] ext4: fast commit: add lock_updates tracepoint
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

Thank you for your review, and I apologize for my delayed response.

 ---- On Wed, 18 Mar 2026 00:21:29 +0800  Steven Rostedt <rostedt@goodmis.o=
rg> wrote ---=20
 > On Tue, 17 Mar 2026 16:46:21 +0800
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
 > > Signed-off-by: Li Chen <me@linux.beauty>
 > > ---
 > >  fs/ext4/ext4.h              | 15 ++++++++
 > >  fs/ext4/fast_commit.c       | 71 +++++++++++++++++++++++++++++-------=
-
 > >  include/trace/events/ext4.h | 61 +++++++++++++++++++++++++++++++
 > >  3 files changed, 132 insertions(+), 15 deletions(-)
 > >=20
 > > diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
 > > index 68a64fa0be926..b9e146f3dd9e4 100644
 > > --- a/fs/ext4/ext4.h
 > > +++ b/fs/ext4/ext4.h
 > > @@ -1037,6 +1037,21 @@ enum {
 > > =20
 > >  struct ext4_fc_inode_snap;
 > > =20
 > > +/*
 > > + * Snapshot failure reasons for ext4_fc_lock_updates tracepoint.
 > > + * Keep these stable for tooling.
 > > + */
 > > +enum ext4_fc_snap_err {
 > > +    EXT4_FC_SNAP_ERR_NONE        =3D 0,
 > > +    EXT4_FC_SNAP_ERR_ES_MISS    =3D 1,
 > > +    EXT4_FC_SNAP_ERR_ES_DELAYED    =3D 2,
 > > +    EXT4_FC_SNAP_ERR_ES_OTHER    =3D 3,
 > > +    EXT4_FC_SNAP_ERR_INODES_CAP    =3D 4,
 > > +    EXT4_FC_SNAP_ERR_RANGES_CAP    =3D 5,
 > > +    EXT4_FC_SNAP_ERR_NOMEM        =3D 6,
 > > +    EXT4_FC_SNAP_ERR_INODE_LOC    =3D 7,
 >=20
 > You don't need to explicitly state the assignments, the enum will increm=
ent
 > them without them.

Agree.

 > > +};
 > > +
 > >  /*
 > >   * fourth extended file system inode data in memory
 > >   */
 > > diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
 > > index d1eefee609120..4929e2990b292 100644
 > > --- a/fs/ext4/fast_commit.c
 > > +++ b/fs/ext4/fast_commit.c
 > > @@ -193,6 +193,12 @@ static struct kmem_cache *ext4_fc_range_cachep;
 > >  #define EXT4_FC_SNAPSHOT_MAX_INODES    1024
 > >  #define EXT4_FC_SNAPSHOT_MAX_RANGES    2048
 > > =20
 > > +static inline void ext4_fc_set_snap_err(int *snap_err, int err)
 > > +{
 > > +    if (snap_err && *snap_err =3D=3D EXT4_FC_SNAP_ERR_NONE)
 > > +        *snap_err =3D err;
 > > +}
 > > +
 > >  static void ext4_end_buffer_io_sync(struct buffer_head *bh, int uptod=
ate)
 > >  {
 > >      BUFFER_TRACE(bh, "");
 > > @@ -983,11 +989,12 @@ static void ext4_fc_free_inode_snap(struct inode=
 *inode)
 > >  static int ext4_fc_snapshot_inode_data(struct inode *inode,
 > >                         struct list_head *ranges,
 > >                         unsigned int nr_ranges_total,
 > > -                       unsigned int *nr_rangesp)
 > > +                       unsigned int *nr_rangesp,
 > > +                       int *snap_err)
 > >  {
 > >      struct ext4_inode_info *ei =3D EXT4_I(inode);
 > > -    unsigned int nr_ranges =3D 0;
 > >      ext4_lblk_t start_lblk, end_lblk, cur_lblk;
 > > +    unsigned int nr_ranges =3D 0;
 > > =20
 > >      spin_lock(&ei->i_fc_lock);
 > >      if (ei->i_fc_lblk_len =3D=3D 0) {
 > > @@ -1010,11 +1017,16 @@ static int ext4_fc_snapshot_inode_data(struct =
inode *inode,
 > >          struct ext4_fc_range *range;
 > >          ext4_lblk_t len;
 > > =20
 > > -        if (!ext4_es_lookup_extent(inode, cur_lblk, NULL, &es, NULL))
 > > +        if (!ext4_es_lookup_extent(inode, cur_lblk, NULL, &es, NULL))=
 {
 > > +            ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_ES_MISS);
 > >              return -EAGAIN;
 > > +        }
 > > =20
 > > -        if (ext4_es_is_delayed(&es))
 > > +        if (ext4_es_is_delayed(&es)) {
 > > +            ext4_fc_set_snap_err(snap_err,
 > > +                         EXT4_FC_SNAP_ERR_ES_DELAYED);
 > >              return -EAGAIN;
 > > +        }
 > > =20
 > >          len =3D es.es_len - (cur_lblk - es.es_lblk);
 > >          if (len > end_lblk - cur_lblk + 1)
 > > @@ -1024,12 +1036,17 @@ static int ext4_fc_snapshot_inode_data(struct =
inode *inode,
 > >              continue;
 > >          }
 > > =20
 > > -        if (nr_ranges_total + nr_ranges >=3D EXT4_FC_SNAPSHOT_MAX_RAN=
GES)
 > > +        if (nr_ranges_total + nr_ranges >=3D EXT4_FC_SNAPSHOT_MAX_RAN=
GES) {
 > > +            ext4_fc_set_snap_err(snap_err,
 > > +                         EXT4_FC_SNAP_ERR_RANGES_CAP);
 > >              return -E2BIG;
 > > +        }
 > > =20
 > >          range =3D kmem_cache_alloc(ext4_fc_range_cachep, GFP_NOFS);
 > > -        if (!range)
 > > +        if (!range) {
 > > +            ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
 > >              return -ENOMEM;
 > > +        }
 > >          nr_ranges++;
 > > =20
 > >          range->lblk =3D cur_lblk;
 > > @@ -1054,6 +1071,7 @@ static int ext4_fc_snapshot_inode_data(struct in=
ode *inode,
 > >                  range->len =3D max;
 > >          } else {
 > >              kmem_cache_free(ext4_fc_range_cachep, range);
 > > +            ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_ES_OTHER)=
;
 > >              return -EAGAIN;
 > >          }
 > > =20
 > > @@ -1070,7 +1088,7 @@ static int ext4_fc_snapshot_inode_data(struct in=
ode *inode,
 > > =20
 > >  static int ext4_fc_snapshot_inode(struct inode *inode,
 > >                    unsigned int nr_ranges_total,
 > > -                  unsigned int *nr_rangesp)
 > > +                  unsigned int *nr_rangesp, int *snap_err)
 > >  {
 > >      struct ext4_inode_info *ei =3D EXT4_I(inode);
 > >      struct ext4_fc_inode_snap *snap;
 > > @@ -1082,8 +1100,10 @@ static int ext4_fc_snapshot_inode(struct inode =
*inode,
 > >      int alloc_ctx;
 > > =20
 > >      ret =3D ext4_get_inode_loc_noio(inode, &iloc);
 > > -    if (ret)
 > > +    if (ret) {
 > > +        ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_INODE_LOC);
 > >          return ret;
 > > +    }
 > > =20
 > >      if (ext4_test_inode_flag(inode, EXT4_INODE_INLINE_DATA))
 > >          inode_len =3D EXT4_INODE_SIZE(inode->i_sb);
 > > @@ -1092,6 +1112,7 @@ static int ext4_fc_snapshot_inode(struct inode *=
inode,
 > > =20
 > >      snap =3D kmalloc(struct_size(snap, inode_buf, inode_len), GFP_NOF=
S);
 > >      if (!snap) {
 > > +        ext4_fc_set_snap_err(snap_err, EXT4_FC_SNAP_ERR_NOMEM);
 > >          brelse(iloc.bh);
 > >          return -ENOMEM;
 > >      }
 > > @@ -1102,7 +1123,7 @@ static int ext4_fc_snapshot_inode(struct inode *=
inode,
 > >      brelse(iloc.bh);
 > > =20
 > >      ret =3D ext4_fc_snapshot_inode_data(inode, &ranges, nr_ranges_tot=
al,
 > > -                      &nr_ranges);
 > > +                      &nr_ranges, snap_err);
 > >      if (ret) {
 > >          kfree(snap);
 > >          ext4_fc_free_ranges(&ranges);
 > > @@ -1203,7 +1224,10 @@ static int ext4_fc_alloc_snapshot_inodes(struct=
 super_block *sb,
 > >                       unsigned int *nr_inodesp);
 > > =20
 > >  static int ext4_fc_snapshot_inodes(journal_t *journal, struct inode *=
*inodes,
 > > -                   unsigned int inodes_size)
 > > +                   unsigned int inodes_size,
 > > +                   unsigned int *nr_inodesp,
 > > +                   unsigned int *nr_rangesp,
 > > +                   int *snap_err)
 > >  {
 > >      struct super_block *sb =3D journal->j_private;
 > >      struct ext4_sb_info *sbi =3D EXT4_SB(sb);
 > > @@ -1221,6 +1245,8 @@ static int ext4_fc_snapshot_inodes(journal_t *jo=
urnal, struct inode **inodes,
 > >      alloc_ctx =3D ext4_fc_lock(sb);
 > >      list_for_each_entry(iter, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
 > >          if (i >=3D inodes_size) {
 > > +            ext4_fc_set_snap_err(snap_err,
 > > +                         EXT4_FC_SNAP_ERR_INODES_CAP);
 > >              ret =3D -E2BIG;
 > >              goto unlock;
 > >          }
 > > @@ -1244,6 +1270,8 @@ static int ext4_fc_snapshot_inodes(journal_t *jo=
urnal, struct inode **inodes,
 > >              continue;
 > > =20
 > >          if (i >=3D inodes_size) {
 > > +            ext4_fc_set_snap_err(snap_err,
 > > +                         EXT4_FC_SNAP_ERR_INODES_CAP);
 > >              ret =3D -E2BIG;
 > >              goto unlock;
 > >          }
 > > @@ -1268,16 +1296,20 @@ static int ext4_fc_snapshot_inodes(journal_t *=
journal, struct inode **inodes,
 > >          unsigned int inode_ranges =3D 0;
 > > =20
 > >          ret =3D ext4_fc_snapshot_inode(inodes[idx], nr_ranges,
 > > -                         &inode_ranges);
 > > +                         &inode_ranges, snap_err);
 > >          if (ret)
 > >              break;
 > >          nr_ranges +=3D inode_ranges;
 > >      }
 > > =20
 > > +    if (nr_inodesp)
 > > +        *nr_inodesp =3D i;
 > > +    if (nr_rangesp)
 > > +        *nr_rangesp =3D nr_ranges;
 > >      return ret;
 > >  }
 > > =20
 > > -static int ext4_fc_perform_commit(journal_t *journal)
 > > +static int ext4_fc_perform_commit(journal_t *journal, tid_t commit_ti=
d)
 > >  {
 > >      struct super_block *sb =3D journal->j_private;
 > >      struct ext4_sb_info *sbi =3D EXT4_SB(sb);
 > > @@ -1286,10 +1318,15 @@ static int ext4_fc_perform_commit(journal_t *j=
ournal)
 > >      struct inode *inode;
 > >      struct inode **inodes;
 > >      unsigned int inodes_size;
 > > +    unsigned int snap_inodes =3D 0;
 > > +    unsigned int snap_ranges =3D 0;
 > > +    int snap_err =3D EXT4_FC_SNAP_ERR_NONE;
 > >      struct blk_plug plug;
 > >      int ret =3D 0;
 > >      u32 crc =3D 0;
 > >      int alloc_ctx;
 > > +    ktime_t lock_start;
 > > +    u64 locked_ns;
 > > =20
 > >      /*
 > >       * Step 1: Mark all inodes on s_fc_q[MAIN] with
 > > @@ -1337,13 +1374,13 @@ static int ext4_fc_perform_commit(journal_t *j=
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
 > >      /*
 > >       * The journal is now locked. No more handles can start and all t=
he
 > >       * previous handles are now drained. Snapshotting happens in this
 > > @@ -1357,8 +1394,12 @@ static int ext4_fc_perform_commit(journal_t *jo=
urnal)
 > >      }
 > >      ext4_fc_unlock(sb, alloc_ctx);
 > > =20
 > > -    ret =3D ext4_fc_snapshot_inodes(journal, inodes, inodes_size);
 > > +    ret =3D ext4_fc_snapshot_inodes(journal, inodes, inodes_size,
 > > +                      &snap_inodes, &snap_ranges, &snap_err);
 > >      jbd2_journal_unlock_updates(journal);
 > > +    locked_ns =3D ktime_to_ns(ktime_sub(ktime_get(), lock_start));
 >=20
 > If locked_ns is only used for the tracepoint, it should either be
 > calculated in the tracepoint, or add:
 >=20
 >     if (trace_ext4_fc_lock_updates_enabled()) {
 >         locked_ns =3D ktime_to_ns(ktime_sub(ktime_get(), lock_start));
=20
Good catch!

 > > +    trace_ext4_fc_lock_updates(sb, commit_tid, locked_ns, snap_inodes=
,
 > > +                   snap_ranges, ret, snap_err);
 >=20
 >     }
 >=20
 > Note, we are going to also add a code to call the tracepoint directly, t=
o
 > remove the double static_branch.
 >=20
 >     https://lore.kernel.org/all/20260312150523.2054552-1-vineeth@bitbyte=
word.org/
 >=20
 > But that code is still being worked on so you don't need to worry about =
it
 > at the moment.

Thank you! I will monitor this patch set and incorporate it into future ver=
sions if possible.

 >=20
 > >      kvfree(inodes);
 > >      if (ret)
 > >          return ret;
 > > @@ -1563,7 +1604,7 @@ int ext4_fc_commit(journal_t *journal, tid_t com=
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
 > > index fd76d14c2776e..dc084f39b74ad 100644
 > > --- a/include/trace/events/ext4.h
 > > +++ b/include/trace/events/ext4.h
 > > @@ -104,6 +104,26 @@ TRACE_DEFINE_ENUM(EXT4_FC_REASON_INODE_JOURNAL_DA=
TA);
 > >  TRACE_DEFINE_ENUM(EXT4_FC_REASON_ENCRYPTED_FILENAME);
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
 > > @@ -2812,6 +2832,47 @@ TRACE_EVENT(ext4_fc_commit_stop,
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
 >=20

Regards,
Li=E2=80=8B

