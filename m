Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0853C0A0D;
	Thu, 14 May 2026 11:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778759145; cv=pass; b=oqMeDGbDiYWXHHV0dTpEws3OBHMPwxbeW3DMBz8yy8WqxZWN9y/YgbB+22ebz1Sg0fINdGjjc9cl4iMCRDlh4/BghwEQyWB2ndPEHAOFEeINblZuuigc3KAoDdIcaJ3iUQx1xEkSoT2ix+9zVaUEDxarF7hSTUyyCw3Tt/RWObk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778759145; c=relaxed/simple;
	bh=7IaLwM3F3TdQuS4EUrjIk7Seym/L3fxN9ib9B8ij0dg=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=NunWxtcmvNiu/oQ0RuL8gGPKPpAN9dP8sPvy9uNmyG1sBnrUAXMsiDn4HD6Q7zAs6/uO5mRLODKbjv7lsNkpMzjY4V+Wf9UNbysCJb26hXc1otbWv2kGu4QMOtognAOMgvUjs8poRhz+N9ntzu0UCvuJmuFdIO6RwiLFzh+FZ9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=es7SLggl; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="es7SLggl"
ARC-Seal: i=1; a=rsa-sha256; t=1778758998; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=f6FYJXiuWD6pO/Jpek/brw441sCi1rT7WEGrrN6uu+0JNbESpVObabgGrwbArX+q4s5Zu7oolUmo/rj+bas/TBb0JXj75MwJd+mrAmBssT+95bkfl1y9nx6Wnb2AfslNNuAqCUFHF4f7pvuu8QXRXuhfYDVfavHmqF4rJGNF1no=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778758998; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=X1BtEueSkLt7Z50X38Na6QbrTWm/zNHCKirt+GzDj/M=; 
	b=FmLZMPLNRjbqbUKp1MkP827FyIauEw5xUVTtdWxpN5Ax1OpyE4OFWxgLmjXMXtuYEGJB3FIYfRsiqFNvyun1EweD6pTtTOvhE5VD3TQULDqHMzs4aYGp8f+OLUUFY09W/LeyGzbf8mzyK9dF0j/4ucVXhSGgdGywExNWUaZTDM4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778758998;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=X1BtEueSkLt7Z50X38Na6QbrTWm/zNHCKirt+GzDj/M=;
	b=es7SLggl8rNaFZOM6TAziHbJRycvRsreLirl6sKEoTVp9ZCKWfCD3tpLC+4raqYp
	S7B1N+OwFqmQLHEBwXEzJn+8C+5JXDjcuRlYm1hOuw7vYqYjIdOAb+C4eb0EA3aeucs
	nF/X4w649BcjaTNz+A5gqLg+b2ZrWeLx1Esg2l2A=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1778758995811367.92445484840755; Thu, 14 May 2026 04:43:15 -0700 (PDT)
Date: Thu, 14 May 2026 19:43:15 +0800
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
Message-ID: <19e264c4f50.3c716cbc1996519.6179579622908588105@linux.beauty>
In-Reply-To: <20260513135741.12ddb97d@gandalf.local.home>
References: <20260511084304.1559557-1-me@linux.beauty>
	<20260511084304.1559557-7-me@linux.beauty> <20260513135741.12ddb97d@gandalf.local.home>
Subject: Re: [RFC v7 6/7] ext4: fast commit: add lock_updates tracepoint
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

 ---- On Thu, 14 May 2026 01:57:41 +0800  Steven Rostedt <rostedt@goodmis.o=
rg> wrote ---=20
 > On Mon, 11 May 2026 16:43:01 +0800
 > Li Chen <me@linux.beauty> wrote:
 >=20
 > > @@ -1346,8 +1383,15 @@ static int ext4_fc_perform_commit(journal_t *jo=
urnal)
 > >      }
 > >      ext4_fc_unlock(sb, alloc_ctx);
 > > =20
 > > -    ret =3D ext4_fc_snapshot_inodes(journal, inodes, inodes_size);
 > > +    ret =3D ext4_fc_snapshot_inodes(journal, inodes, inodes_size,
 > > +                      &snap_inodes, &snap_ranges, &snap_err);
 > >      jbd2_journal_unlock_updates(journal);
 > > +    if (trace_ext4_fc_lock_updates_enabled()) {
 > > +        locked_ns =3D ktime_to_ns(ktime_sub(ktime_get(), lock_start))=
;
 > > +        trace_ext4_fc_lock_updates(sb, commit_tid, locked_ns,
 > > +                       snap_inodes, snap_ranges, ret,
 > > +                       snap_err);
 >=20
 > Please change this to:
 >=20
 >         trace_call__ext4_fc_lock_updates(...)
 >=20
 > As the "trace_ext4_fc_lock_updates_enabled()" already has the static
 > branch. No need to do it twice anymore. 7.1 introduced the
 > "trace_call__foo()" that will do a direct call to the tracepoints
 > registered, without the need for another static branch.

Thanks, will do it.


Regards,
Li=E2=80=8B

