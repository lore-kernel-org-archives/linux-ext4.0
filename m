Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D203E9F8F
	for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2026 15:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773760924; cv=none; b=ULnsHtFrRTYpynkk5jfbydg0bzMk9R8PlSJ2PAA9RNVho8gpjsf+8E7UbW+CjxJ8rBFKcxfH8PmQ3ZfZ7o1hia6u9dG8fhkwbg9uAiYmuiEfkiR6OVNEeB+gSdN3FCRPsdoWnLB4L68Cq4d0FuFd/3MP4pvfuC71Do9kgAi9vhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773760924; c=relaxed/simple;
	bh=WwEwhyHNmayWlIvi0P+sJ82C6u3NzftKNc6t1AAu+xE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ptp9rWi21Hoz+dTm8kwaFLaUjVe4FB6mo1XXSshll1AR5UpFAIkvRcjUKIuXims+9gC3U/mwBRj2t8HpW4dApx1Ma73oRIsykbjb1HP7Uk0FL0EJ1Z7xRoMSzmLDXVaN0d37eWc8MmR1mzgjD+usH5SxQjB7z+4ymsyoVLTt7Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=EtsGGbmm; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="EtsGGbmm"
Received: from macsyma.thunk.org (pool-173-48-82-106.bstnma.fios.verizon.net [173.48.82.106])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62HFLXVW003973
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Mar 2026 11:21:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1773760896; bh=CTBRGZUmK9RlHnhfGU2Ws8vhw9aY79StbhBWA/ABa4w=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=EtsGGbmmAzzbsnL6ArVgjwHEuJyjnuveyeeHX0a4+t58Ji+Ine0HTV3WrhARxhF6+
	 aywPLR8mdMrhbwQdt6AY7E6cg6IMNmH0/myjv8adGvLbeqhKB671lWGwSN2HdbmUmI
	 TieVb50gifPK/ZRxMSc1yrpoMLnJwJgSAC7pFrDt2cVxNN7J3eHobBFjoXorqkLhe2
	 wAy/SzM/DCAHZ4LVJM3dcDeOC2JNcJnocpWHhZwXKlINdU+tjuabWyIBpFhaWIHES1
	 cA1EQTKnkIfp4+8A3bbsH3dWXdqCJV0jqX3OZg3GlXvGuqTz1uMf9EOocjpcN10Itl
	 Qw4iLFnvuKxbg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 090135DFF22F; Tue, 17 Mar 2026 11:20:33 -0400 (EDT)
Date: Tue, 17 Mar 2026 11:20:32 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, bpf@vger.kernel.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bernd@bsbernd.com>,
        Neal Gompa <neal@gompa.dev>, Amir Goldstein <amir73il@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, John@groves.net
Subject: Re: [PATCHBLIZZARD v7] fuse/libfuse/e2fsprogs: containerize ext4 for
 safer operation
Message-ID: <20260317152032.GA55644@macsyma-wired.lan>
References: <20260223224617.GA2390314@frogsfrogsfrogs>
 <CAJnrk1Yd1J60-Ek=O7jzZQg454pbr3O=b71yZHzYbrWfqJr__w@mail.gmail.com>
 <20260316180408.GN6069@frogsfrogsfrogs>
 <CAJnrk1bmJYMt27xedN2Xza0KPXfYEbh-9g=3fNWru-HRM9WFEw@mail.gmail.com>
 <20260316234137.GJ1742010@frogsfrogsfrogs>
 <208bfbd2-d671-462c-925f-4d51b7df1f18@gmail.com>
 <20260317135921.GB53921@macsyma-wired.lan>
 <8adf57a0-ee3f-4554-bb0d-cedcf6c51e47@gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8adf57a0-ee3f-4554-bb0d-cedcf6c51e47@gmail.com>

On Tue, Mar 17, 2026 at 10:05:59AM -0400, Demi Marie Obenour wrote:
> 
> This doesn't require a physical attack.  An attacker who has previously
> gained root access could use a metadata parsing attack to keep that
> access across reboots.

So the concern that you are raising is that an attacker might be able
to corrupt the metadata in such a way that it triggers some kind of
buffer overrun or other zero-day attack, but that it will *not*
trigger an EXT4-fs error indication (since if it does, then on the
next reboot, an fsck will be forced since the file system will be
marked corrupt).  Is that correct?

That's... possible, but in my experience, the vast majority of syzbot
reported bugs involving fuzzed file systems do actually trigger the
file system being detected as corrupted.  It's just that the file
system is mounted in errors=continue mode, as opposed to
errors=remount-ro or errirs=panic.  And more often than not, it
triggers a warning or an OOPS, which is considered CVE fodder.  Not
all syzbot issues can be translated into a privilege escalation
attack.

But if the attacker could pull it off, and reliably find a way to
force the system to trip against the hidden file system corruption, I
agree that this would represent a violation of the security model for
Android, which is that a reboot should always get the system back to a
secure state.  I will note, though, that you can also carry out
zero-day attacks by putting malicious data into an image file that
triggers a buffer overrun, and in some ways, that might be an easier
way to persist some kind of security vulnerability across reboots
compared to trying to find a more complex file system metadata parsing
attack.

Ultimately, it's really a cost/benefit tradeoff.  We need to take a
big picture view when considering which attacks we should be expending
resources to protect against, since security mitigation budget is not
infinite.  That being said, patches are welcome.  :-)

Cheers,

						- Ted
