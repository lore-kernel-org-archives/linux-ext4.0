From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 10882] New: Different kernel crashes on
 corrupted filesystems
Date: Sat, 7 Jun 2008 12:19:40 -0700
Message-ID: <20080607121940.8ee6044a.akpm@linux-foundation.org>
References: <bug-10882-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752799AbYFGTUI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 Jun 2008 15:20:08 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m57JJfsR030178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 12:19:42 -0700
Received: from y.localdomain (localhost [127.0.0.1])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with SMTP id m57JJeuG000513
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 12:19:41 -0700
In-Reply-To: <bug-10882-10286@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat,  7 Jun 2008 09:19:33 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> 
> http://bugzilla.kernel.org/show_bug.cgi?id=10882

Various ext3 crashes when mounting corrupted images.
