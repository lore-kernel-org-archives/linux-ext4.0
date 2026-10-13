Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B7E3CB2FA;
	Tue, 13 Oct 2026 19:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791919395; cv=none; b=FWhJo44I6mUkHVzMT5YPwCpsdbJQtwTbdFsKNMWQOUdCmdshgH8V6KWsqqIav7S7ugMksQqjMg7zLU+VxAtYpOz/irsytHxSbz6lTM+94443ak47H0koZfOz1V/wMTCSuIRgXRyorGLpC5tvbDEN2OHpnFhrt1ovgwP8xyPOLkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791919395; c=relaxed/simple;
	bh=fLVJvchgOrr/FoB90dGBUSI2t4PI/G0g/rO3vrxD65Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QeprmwOdA2uwtKOrMNm5uNg9SypBqa/GiG8rNKqZcFbOYJ5As5ZoWy84WCaIV5vQCG3nzNgcUUX6/R2Wxm8Sw3ZN1+7jWU+libDn+ioZlL5E9R5FgpkJug5g25Igz7RhFGvN7qSkSr+a8vt3paMWLYtV/F5J8YnngYn6NI01KiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FwPoKWZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FwPoKWZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193DF1F000FF;
	Tue, 13 Oct 2026 19:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791919393;
	bh=uTpljzLsM4ar3FCb7KQFeG+fZveMF5TVm3VuizQw5Aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FwPoKWZh4Jdm3xYp5Z2UEeji2S0sc8BibE2kmFgYdtbRFkVtAG+F5oTeMF4HSX4wA
	 BXwhu4Tg7faX7C/wi2avb/ftAbZ4HLphkSVhh+MntGKpAliF/UFlt/2pV5o+4PXo/5
	 /u8Po9+te8dhKEnreffeVmXfMHWWhq2MPbxD3jnPckRBfhwcfD6zMtjOwEf3YZWO3Y
	 ip0fjcgrbnRKJsrjJihEcTbjn5hnNgLNmrb6KmLxMRnSJr5MixImxpDg305gYYmOJq
	 fo4s0av+Pr9cTli2dvk0TXdDYUFSmsLku+c4SM9Rf6l7mI3CjwNwXQ01x/iRDl3BYm
	 mMWZVTHtI4SAw==
Date: Tue, 13 Oct 2026 21:23:07 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, linux-afs@lists.infradead.org, 
	v9fs@lists.linux.dev, linux-trace-kernel@vger.kernel.org, ntfs3@lists.linux.dev, 
	stable@vger.kernel.org
Subject: Re: [PATCH 0/8] fs: fix a range of UAFs during rcu pathwalk caused
 by non-rcu frees
Message-ID: <20261013-tante-unwiederholbar-summieren-de1079d8fb05@brauner>
References: <20261009-work-fixes-rcu-v1-0-7446d2d335e6@kernel.org>
 <r72foycb4ol4hywl5m2sj6h6yxee3nladaw7g2zdxhejmhrkgc@v24cfppcak2h>
 <20261012-gaukeln-zeltlager-etikettieren-73ae50ccac01@brauner>
 <voobrqryqulmrq7gyt5vdwuiqd3wrhsrgfcadszclcgs6smw64@qb7yne64airm>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <voobrqryqulmrq7gyt5vdwuiqd3wrhsrgfcadszclcgs6smw64@qb7yne64airm>

On Tue, Oct 13, 2026 at 12:47:58PM +0200, Jan Kara wrote:
> On Mon 12-10-26 12:42:06, Christian Brauner wrote:
> > On Mon, Oct 12, 2026 at 12:36:15PM +0200, Jan Kara wrote:
> > > On Fri 09-10-26 23:51:50, Christian Brauner wrote:
> > > > While working on eliding the grace period in namespace_unlock() I went
> > > > through what filesystems free when they're shut down and what a pathwalk
> > > > in rcu mode can still read at that point. Since 66a97c2ec953's rcu
> > > > pathwalk fixes that's the filesystem's job. Whatever ->permission(),
> > > > ->d_revalidate(), ->get_link(), ->d_hash() and ->d_compare() look at in
> > > > rcu mode has to be freed after a grace period. A few filesystems don't
> > > > do that.
> > > > 
> > > > Most of it is hidden by umount(2). namespace_unlock() waits for a grace
> > > > period before it drops the mounts, so a walker that was inside the
> > > > filesystem is gone by the time the filesystem is shut down.
> > > > 
> > > > But the last reference to a mount doesn't have to go away in umount(2).
> > > > A chdir() out of a lazily unmounted directory or the close() of the last
> > > > file on it drops it without a grace period. A walker can then still be
> > > > in the filesystem while ->put_super() and ->kill_sb() free what it
> > > > reads.
> > > 
> > > Good catches! But I find it very counter-intuitive that pathname lookups
> > > can still be running against a filesystem while its ->put_super is called.
> > > People will keep forgetting about that and as a result these UAF bugs will
> > > be introduced again. Isn't it feasible we'd guarantee to the filesystem
> > > ->put_super() gets called only after all lookups are done (i.e., after RCU
> > > grace period expires)?
> > > 
> > > I understand this is a hairy bussiness because this has userspace visible
> > > implications (like when filesystem's sysfs files disappear, when the bdev
> > > really gets unused, etc.) but keeping all filesystems safe to run RCU
> > > lookup after ->put_super() will be IMHO a headache.
> > 
> > I don't think delaying put_super() or freeing the superblock helps.
> > That's not where the issue is. The issue is with sb->s_fs_info being
> > available after a grace period and that can go away in different
> > locations ->put_super() or ->kill_sb().
> 
> So my thinking was: Cannot we separate the teardown of mounts and the
> teardown of the sb by an RCU grace period? Then by the time the filesystem
> gets to any freeing of filesystem related structures all RCU lookups are
> guaranteed to be done so there's no problem with them accessing possibly
> freed structures pointed to by the sb.
> 
> But then I've read more of the changelogs and AFAIU getting rid of the RCU
> grace period waiting in the unmount path is actually your point to speedup

So I prototyped your thing and all version I could see working end up
penalizing umount and filesystem shutdown quite heavily. Maybe I'm not
imagnative enough but everything involving synchronize_rcu* should be
kicked in the n*ts. Because if you're going onto big machines your
workloads will get said kick.
