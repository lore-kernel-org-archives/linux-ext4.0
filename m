Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BACA359A6D
	for <linux-ext4@vger.kernel.org>; Fri,  3 Apr 2026 21:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775250059; cv=none; b=ZHfXaeAx9EopRdMqO59Ju/r3uoG92rsrzA0gR7LALmDhYDaDGE+vhWyiWBKnSSXoaUKiMktbfn0riUinGGztnyO3T8P9HOUOqrP6SvVXbh3L0gggeoxfZDWQgFZP/Rfpb/2MrlTqW0nQ8udS5tgGfA0JxipKQfJI1BydIWQ9CuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775250059; c=relaxed/simple;
	bh=m3KyOzcwFza2YrZ0Ws/oVBeVcwAnkwZAS+8LZIMTzYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PG4ezb2mLPuqAT4KYfKaH9CQ87evuKY+CIotqYJ9uKYpW02bgyCV0Qck0ISZL+nxSDFrWv0sVLaxqsKpLoj0FNxkJa0eMIj2i7sPM/7acg8GM1JI3qcaW2KdKA8OyWmkSjszSuaPlsBeit/isM8b2XxCAQexMoHruIuQWHk+6Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=g8L5NGmp; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="g8L5NGmp"
Received: from macsyma.thunk.org (pool-173-48-112-174.bstnma.fios.verizon.net [173.48.112.174])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 633L0kwp022464
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 3 Apr 2026 17:00:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775250048; bh=qa4v8+CyqLiUjXLw1YwUpb/PTlafHDtV351thSH6QDg=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=g8L5NGmpBRs5d66NBK7mXS9+GJYwrbnjHcgKdE4+lBbqcSR1VzI7ToHY8budJ3oc9
	 yj0RfXyMfp9hlFBZMb5J5rh6+bBY1RuEqhYJbGguBL8sFjhB+l7WjNKipkmqUSHMmP
	 DP7Vg+hSt8k7CRQUk55dfEltggEe5Sz/uH2E/QGghIUO9jiHp5qWbAenT4bmIrHiDe
	 w0ItFM84VKJyJMj8Y9yFcd7i62xhmLyJp1RvPRS5cyJteyRV6/qpqU2ILNuZgNBDnV
	 ZJWDRSQyZHv387LqQ509Gy9ZMjQj8J6nMieO7DSDlWndJkEGvnyHu7iaCdIJ8ILO1g
	 vUHWh7uUsEbVg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id C5EFF610D4B6; Fri,  3 Apr 2026 17:00:46 -0400 (EDT)
Date: Fri, 3 Apr 2026 17:00:46 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 1/3] libsupport: fix portability issues with the bthread.c
Message-ID: <20260403210046.GC16311@macsyma-wired.lan>
References: <20260403040328.2385083-1-tytso@mit.edu>
 <20260403040328.2385083-2-tytso@mit.edu>
 <20260403041624.GD6254@frogsfrogsfrogs>
 <20260403115313.GA12260@macsyma-wired.lan>
 <20260403151535.GI6254@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403151535.GI6254@frogsfrogsfrogs>

On Fri, Apr 03, 2026 at 08:15:35AM -0700, Darrick J. Wong wrote:
> > It's "autoheader".  Whenver you add or remove tests to configure.ac,
> > you need to run "autoconf ; autoheader".  If you don't run
> > "autoheader", then even if the autoconf's feature test enables some
> > new feature test, say HAVE_PR_SET_IO_FLUSHER, the feature won't
> > actually be enabled in the #ifdef.
> 
> Aha!  Thanks for that tip; I'll go fix my dev branch.

Just to give more context, there are two ways that configure scripts
can pass the feature definitions to programs.  One is via the command
line of the compiler.  The problem with that is if you have dozens of
options like -DHAVE_PR_SET_IO_FLUSHER for every single compile, it
bloats the MAKELOG files and makes it hard to read, and eventually you
can run into the command-line length limits.

The other way is via a config.h file which is then #included in each
source file.  But for *that* to work, the config.h.in file needs to
have a template for echo variable that can be #defined.  And that's
what autoheader takes care of for you.  Simpler projects that don't
use a config.h file and pass everything on the compiler's command line
don't need to use autoheader.

For a demonstration, try editing lib/config.h.in to remove the lines:

-/* Define to 1 if PR_SET_IO_FLUSHER is present */
-#undef HAVE_PR_SET_IO_FLUSHER

Then "rm lib/config.h" and run "./config.status", and examine
lib/config.h.  You will see that HAVE_PR_SET_IO_FLUSHER is no longer
defined in the config.h file.  Then run "autoheader", and then re-run
"./config.status", and you will see that HAVE_PR_SET_IO_FLUSHER is
properly defined.

Cheers,

					- Ted
