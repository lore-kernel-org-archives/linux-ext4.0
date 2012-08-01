From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 unknown problem
Date: Wed, 1 Aug 2012 12:18:24 -0400
Message-ID: <20120801161824.GB27989@thunk.org>
References: <927688619.179881343809505627.JavaMail.root@shiva>
 <371434290.179901343809839004.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, info <info@plaintext.sk>
To: LuVar <luvar@plaintext.sk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42551 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab2HAQSa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Aug 2012 12:18:30 -0400
Content-Disposition: inline
In-Reply-To: <371434290.179901343809839004.JavaMail.root@shiva>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 01, 2012 at 09:30:39AM +0100, LuVar wrote:
> 
> File does not exist... (if there is something to turn on in kernel config, I could do that for future...)

The options you need to enable to use ftrace are:

    CONFIG_FUNCTION_TRACER
    CONFIG_FUNCTION_GRAPH_TRACER
    CONFIG_STACK_TRACER
    CONFIG_DYNAMIC_FTRACE    

There's a pretty good tutorial here: http://lwn.net/Articles/365835/

If you are willing to compile your own kernel, can you try going to
the latest 3.5 kernel and see if the problem still affects you there?

    	       	      	      	 - Ted
