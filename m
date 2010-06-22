From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 10871] Apparent infinite loop on reading broken filesystem
Date: Tue, 22 Jun 2010 12:35:05 -0700
Message-ID: <20100622123505.ee11d56f.akpm@linux-foundation.org>
References: <bug-10871-27@https.bugzilla.kernel.org/>
	<201006221926.o5MJQpIS026510@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751438Ab0FVTfH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jun 2010 15:35:07 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o5MJZ5Uv010044
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jun 2010 12:35:06 -0700
Received: from akpm.mtv.corp.google.com (localhost [127.0.0.1])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with SMTP id o5MJZ5EF030529
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jun 2010 12:35:05 -0700
In-Reply-To: <201006221926.o5MJQpIS026510@demeter.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 22 Jun 2010 19:26:51 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=10871

Anyone interested in taking a look at this one?  ext2 gets itself
stuck handling a broken fs with errors=continue.  There's an fs
image attached to the report for purposes of reproducing it.
