From: Carlos Carvalho <carlos@fisica.ufpr.br>
Subject: Re: how to quotacheck with the new quota implementation (hidden
 inode)?
Date: Thu, 31 Jan 2013 20:41:24 -0200
Message-ID: <20746.62228.857265.19060@fisica.ufpr.br>
References: <20730.1955.395545.141779@fisica.ufpr.br>
	<20130121054741.GB321@thunk.org>
	<20746.49010.569691.44452@fisica.ufpr.br>
	<CAGr1F2F=mffm7PORykm2CbXt3EWt1=Zgerw-OEy7oGzUQ2dEQA@mail.gmail.com>
	<20746.49740.638811.698394@fisica.ufpr.br>
	<20130131220312.GA15322@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Aditya Kali <adityakali@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fisica.ufpr.br ([200.17.209.129]:41751 "EHLO fisica.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab3AaWl0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2013 17:41:26 -0500
In-Reply-To: <20130131220312.GA15322@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for the detailed instructions.

Theodore Ts'o (tytso@mit.edu) wrote on 31 January 2013 17:03:
 >If you use quota with a freshly created file
 >system, it works pretty well, as long as the usage quota information
 >never gets inconsistent (or if you are using the quota system for
 >usage tracking only and not for quota enforcement).  But if you try to
 >add the quota feature to an already existing file system which has
 >files already pre-populated, there are some definite issues that need
 >fixing.   :-(

That's what I'm doing: in a new filesystem I use the new
implementation, in another I use the vfs one, because it's populated.
