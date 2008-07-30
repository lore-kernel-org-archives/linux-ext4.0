From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Bug 11175] New: ext3 BUG in add_dirent_to_buf+0x6c/0x269
Date: Wed, 30 Jul 2008 10:06:43 -0500
Message-ID: <48908383.5070107@redhat.com>
References: <bug-11175-27@http.bugzilla.kernel.org/> <20080729171207.d88728cf.akpm@linux-foundation.org> <20080730024856.GE29748@mit.edu> <488FDA0A.5020408@redhat.com> <20080730040348.GA8956@mit.edu> <alpine.DEB.1.10.0807300752390.10840@swallowtail>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, bugme-daemon@bugzilla.kernel.org
To: Asheesh Laroia <kernel.bugzilla@asheesh.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbYG3PH1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Jul 2008 11:07:27 -0400
In-Reply-To: <alpine.DEB.1.10.0807300752390.10840@swallowtail>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

FWIW, the gcc bug is at:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=36533

-Eric
