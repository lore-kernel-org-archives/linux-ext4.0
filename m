From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 9692] New: journal_data mount option causes filesystem
 corruption with blocksize != 4096
Date: Tue, 26 Feb 2008 13:48:52 -0800
Message-ID: <20080226134852.04ddada7.akpm@linux-foundation.org>
References: <bug-9692-27@http.bugzilla.kernel.org/>
	<20080105191552.ee114b6b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	bugme-daemon@bugzilla.kernel.org, h.judt@gmx.at
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764747AbYBZVuM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Feb 2008 16:50:12 -0500
In-Reply-To: <20080105191552.ee114b6b.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 5 Jan 2008 19:15:52 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat,  5 Jan 2008 09:52:15 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=9692
> >
> >            Summary: journal_data mount option causes filesystem corruption
> >                     with blocksize != 4096
> >            Product: File System
> >            Version: 2.5
> >      KernelVersion: 2.6.23.9
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: high
> >           Priority: P1
> >          Component: ext3
> >         AssignedTo: akpm@osdl.org
> >         ReportedBy: h.judt@gmx.at
> > 
> > 
> > Most recent kernel where this bug did not occur: -
> > Older kernels have this problem too (I think I noticed this booting >= 2.6.21,
> > definitely 2.6.22).
> 
> I'm getting the feeling that we should just disable data=journal.  Make it
> use data=ordered mode instead.  It isn't getting a lot of attention..
> 

As discussed today - this is the bug which makes me wonder how
useful/popular journalled-data mode is.
