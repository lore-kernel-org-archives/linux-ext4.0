From: Wilmer van der Gaast <wilmer@gaast.net>
Subject: Re: Bug#692104: linux-image-3.2.0-3-amd64: NULL pointer dereference
  in ext4fs
Date: Sat, 24 Nov 2012 00:00:08 +0000
Message-ID: <50B00E08.1020801@gaast.net>
References: <50938953.6010001@gaast.net> <1351866830.13356.100.camel@deadeye.wl.decadent.org.uk> <509440A3.5020604@gaast.net> <20121108153048.GA32709@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-ext4@vger.kernel.org,
	692104@bugs.debian.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from roy.gaast.net ([80.101.33.21]:37183 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322Ab2KXAAN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Nov 2012 19:00:13 -0500
In-Reply-To: <20121108153048.GA32709@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Strangely, this has happened again a few days ago. Very similar 
backtrace, and again triggered by Firefox. Annoyingly it was no longer 
running within strace.


Wilmer v/d Gaast.

-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +
