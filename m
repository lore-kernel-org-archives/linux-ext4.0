From: Carlos Carvalho <carlos@fisica.ufpr.br>
Subject: Re: how to quotacheck with the new quota implementation (hidden
 inode)?
Date: Thu, 31 Jan 2013 20:44:40 -0200
Message-ID: <20746.62424.592474.986002@fisica.ufpr.br>
References: <20730.1955.395545.141779@fisica.ufpr.br>
	<20130121054741.GB321@thunk.org>
	<20746.49010.569691.44452@fisica.ufpr.br>
	<CAGr1F2F=mffm7PORykm2CbXt3EWt1=Zgerw-OEy7oGzUQ2dEQA@mail.gmail.com>
	<20746.49740.638811.698394@fisica.ufpr.br>
	<20130131220312.GA15322@thunk.org>
	<20130131222817.GB13525@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Aditya Kali <adityakali@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fisica.ufpr.br ([200.17.209.129]:41751 "EHLO fisica.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326Ab3AaWol (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2013 17:44:41 -0500
In-Reply-To: <20130131222817.GB13525@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara (jack@suse.cz) wrote on 31 January 2013 23:28:
 >> 3) mount the file system; observe that the quota tools don't realize
 >> that they should be trying to do the quota thing.
 >  What version of quota-tools are you using? If I didn't screw up
 >something, version 4.01 shouldn't need the -o quota mount option anymore...

4.01, from Debian unstable. -o quota is necessary for the new
implementation to track usage, no? I put it in fstab, so quota appears
in /proc/mounts.
