From: Carlos Carvalho <carlos@fisica.ufpr.br>
Subject: Re: how to quotacheck with the new quota implementation (hidden inode)?
Date: Thu, 31 Jan 2013 17:13:16 -0200
Message-ID: <20746.49740.638811.698394@fisica.ufpr.br>
References: <20730.1955.395545.141779@fisica.ufpr.br>
	<20130121054741.GB321@thunk.org>
	<20746.49010.569691.44452@fisica.ufpr.br>
	<CAGr1F2F=mffm7PORykm2CbXt3EWt1=Zgerw-OEy7oGzUQ2dEQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fisica.ufpr.br ([200.17.209.129]:41751 "EHLO fisica.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab3AaTNS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2013 14:13:18 -0500
In-Reply-To: <CAGr1F2F=mffm7PORykm2CbXt3EWt1=Zgerw-OEy7oGzUQ2dEQA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aditya Kali (adityakali@google.com) wrote on 31 January 2013 11:04:
 >By default, only usage is enabled when the filesystem is mounted. You
 >will need to call quotaon to turn on limit enforcement. If it doesn't
 >even after that, then its a bug.

Ah, fine. It works, fortunately :-). Thanks.

It's not clear what can be dropped and what must still be used in the
new implementation. It'd be nice to state it in the man page of
tune2fs, for example. I thought that if we wanted to stop quotas it'd
be necessary to umount and tune2fs again.
