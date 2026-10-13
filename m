Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F61953ED0B;
	Tue, 13 Oct 2026 19:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791919562; cv=none; b=TGTRBQWxI9Qdz/8yWRCiCuCIRFIfuN3hCzrmWCE4+pEHcREy3OQrhYY4tGPHCIqMDuX7JuvbvZrkAJKS6NEgwmsZ5iR84FfMampzp/5Az63kcn6RUdDLWpDEq80hieyp7iFRl5jajK1oZ+bb5ae7xMOmRczbcputA/HLBcXKzI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791919562; c=relaxed/simple;
	bh=O2WfSHA5BqmJQAhI3glLScjeo8JowpQjhgl4D+5znds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jCKx/cFWdzbpa6+qoNmvLM0yLjvwUDDhpC22SAYaccnIbAW2ezJk0f4KsF2hdXMi+s1S9L/+csNg1xpBiZ1w92DNBTexGOpwqp1mxsdttw2a7k03ku5ZG3Wpme3/1s+ceDCEHrVehir86TrRc55VEKM6TbhA3VcKrzEwjJ7C91w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LEQ4jgJr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LEQ4jgJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6C61F000FF;
	Tue, 13 Oct 2026 19:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791919560;
	bh=q3/jPWbD4Y65ng+PTGU9BYhfLvNaBq2HBFRRf6YGolQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LEQ4jgJra/xBSGA0p1PCZ+WwEZAZgvu+Q5WPbH7rK9mmcFgJ8tHQ2YH29qmbx5KdP
	 U5IfMxG4ZWnMNMHzWJsYqQufelcGHfg0O06CqNvnQpy+MCGdA3FkbScCSF/ZrtQJ38
	 2ZzzZxwY0wVO0FUTQsEFWoQd6fm7Pt0xacEcpSz8/gFyCKbYLb0cqM9iQwopsZBBAo
	 PoFpG3N8mzCdgLYVkj6XYnRfdzBXqcWC/ya/TxuoKk17CRCttnfSoLIxJoRLiGavJ4
	 fe4QirKOIpIGuo9JevjIjMz29JbxJxD0am0zmRpYYolRErE62oD++XiuzeG3kGREtq
	 m5t2vRlyVTqUQ==
Date: Tue, 13 Oct 2026 21:25:55 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, 
	v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, ntfs3@lists.linux.dev, 
	stable@vger.kernel.org
Subject: Re: [PATCH 0/8] fs: fix a range of UAFs during rcu pathwalk caused
 by non-rcu frees
Message-ID: <20261013-hektik-kommunal-zischen-f7e37ee3ddff@brauner>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
 <r72foycb4ol4hywl5m2sj6h6yxee3nladaw7g2zdxhejmhrkgc@v24cfppcak2h>
 <20261012-gaukeln-zeltlager-etikettieren-73ae50ccac01@brauner>
 <voobrqryqulmrq7gyt5vdwuiqd3wrhsrgfcadszclcgs6smw64@qb7yne64airm>
 <20261013-tante-unwiederholbar-summieren-de1079d8fb05@brauner>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261013-tante-unwiederholbar-summieren-de1079d8fb05@brauner>

On Tue, Oct 13, 2026 at 09:23:07PM +0200, Christian Brauner wrote:
> On Tue, Oct 13, 2026 at 12:47:58PM +0200, Jan Kara wrote:
> > On Mon 12-10-26 12:42:06, Christian Brauner wrote:
> > > On Mon, Oct 12, 2026 at 12:36:15PM +0200, Jan Kara wrote:
> > > > On Fri 09-10-26 23:51:50, Christian Brauner wrote:
> > > > > While working on eliding the grace period in namespace_unlock() I went
> > > > > through what filesystems free when they're shut down and what a pathwalk
> > > > > in rcu mode can still read at that point. Since 66a97c2ec953's rcu
> > > > > pathwalk fixes that's the filesystem's job. Whatever ->permission(),
> > > > > ->d_revalidate(), ->get_link(), ->d_hash() and ->d_compare() look at in
> > > > > rcu mode has to be freed after a grace period. A few filesystems don't
> > > > > do that.
> > > > > 
> > > > > Most of it is hidden by umount(2). namespace_unlock() waits for a grace
> > > > > period before it drops the mounts, so a walker that was inside the
> > > > > filesystem is gone by the time the filesystem is shut down.
> > > > > 
> > > > > But the last reference to a mount doesn't have to go away in umount(2).
> > > > > A chdir() out of a lazily unmounted directory or the close() of the last
> > > > > file on it drops it without a grace period. A walker can then still be
> > > > > in the filesystem while ->put_super() and ->kill_sb() free what it
> > > > > reads.
> > > > 
> > > > Good catches! But I find it very counter-intuitive that pathname lookups
> > > > can still be running against a filesystem while its ->put_super is called.
> > > > People will keep forgetting about that and as a result these UAF bugs will
> > > > be introduced again. Isn't it feasible we'd guarantee to the filesystem
> > > > ->put_super() gets called only after all lookups are done (i.e., after RCU
> > > > grace period expires)?
> > > > 
> > > > I understand this is a hairy bussiness because this has userspace visible
> > > > implications (like when filesystem's sysfs files disappear, when the bdev
> > > > really gets unused, etc.) but keeping all filesystems safe to run RCU
> > > > lookup after ->put_super() will be IMHO a headache.
> > > 
> > > I don't think delaying put_super() or freeing the superblock helps.
> > > That's not where the issue is. The issue is with sb->s_fs_info being
> > > available after a grace period and that can go away in different
> > > locations ->put_super() or ->kill_sb().
> > 
> > So my thinking was: Cannot we separate the teardown of mounts and the
> > teardown of the sb by an RCU grace period? Then by the time the filesystem
> > gets to any freeing of filesystem related structures all RCU lookups are
> > guaranteed to be done so there's no problem with them accessing possibly
> > freed structures pointed to by the sb.
> > 
> > But then I've read more of the changelogs and AFAIU getting rid of the RCU
> > grace period waiting in the unmount path is actually your point to speedup
> 
> So I prototyped your thing and all version I could see working end up
> penalizing umount and filesystem shutdown quite heavily. Maybe I'm not
> imagnative enough but everything involving synchronize_rcu* should be
> kicked in the n*ts. Because if you're going onto big machines your
> workloads will get said kick.

And one thing I forgot to say: that requirement exists today. It is
entirely accidental that this wasn't an issue in the umount() path
because of the synchronize_rcu* in there. But said grace period doesn't
exist if you e.g., chdir() out of a mount and put the last reference
while still in lookup. Then said filesystems are fscked today because
that is a requirement. And various reproducers in this series illustrate
that.
