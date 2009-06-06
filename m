From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
Date: Sat, 6 Jun 2009 01:17:26 -0300
Message-ID: <20090606041726.GA18112@khazad-dum.debian.net>
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com> <4A293084.5010400@tuffmail.co.uk> <4A2937CC.7070503@redhat.com> <4A294B15.9070209@tuffmail.co.uk> <ac3eb2510906050951o200c3aeex56dcb32bf29d0607@mail.gmail.com> <4A299151.3040109@tuffmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Aioanei Rares <krnl.list@gmail.com>,
	linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35625 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753144AbZFFER3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 6 Jun 2009 00:17:29 -0400
Content-Disposition: inline
In-Reply-To: <4A299151.3040109@tuffmail.co.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 05 Jun 2009, Alan Jenkins wrote:
> Not quite. Ted says it's already reported as
>
>    http://bugzilla.kernel.org/show_bug.cgi?id=13292
>
> It includes an strace log which implicates the use of both mmap() and  
> write() on the same file.  Sounds scary :-).

Run Cyrus-IMAPd on that.  It will cause the entire house to come down if
you have any sort of misbehaviour when userspace is doing extremely
annoying things.  Cyrus-imapd is the mmap() test from hell.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
