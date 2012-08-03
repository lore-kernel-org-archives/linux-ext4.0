From: luvar@plaintext.sk
Subject: Re: ext4 unknown problem
Date: Fri, 3 Aug 2012 08:10:08 +0100 (GMT+01:00)
Message-ID: <1979415850.180301343977808646.JavaMail.root@shiva>
References: <1907038122.180281343977772253.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, info <info@plaintext.sk>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.plaintext.sk ([81.0.124.6]:60960 "EHLO shiva.plaintext.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab2HCHKN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Aug 2012 03:10:13 -0400
In-Reply-To: <1907038122.180281343977772253.JavaMail.root@shiva>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I will compile my kernel with these options, but I have question what to do now. Should I ignore current state (locked journaling proccess) and just sync and reboot? (I have no problem, but I would like to try to investigate current problem if it is possible with my current kernel config).

By LuVar.


----- "Theodore Ts'o" <tytso@mit.edu> wrote:

> On Wed, Aug 01, 2012 at 09:30:39AM +0100, LuVar wrote:
> > 
> > File does not exist... (if there is something to turn on in kernel
> config, I could do that for future...)
> 
> The options you need to enable to use ftrace are:
> 
>     CONFIG_FUNCTION_TRACER
>     CONFIG_FUNCTION_GRAPH_TRACER
>     CONFIG_STACK_TRACER
>     CONFIG_DYNAMIC_FTRACE    
> 
> There's a pretty good tutorial here: http://lwn.net/Articles/365835/
> 
> If you are willing to compile your own kernel, can you try going to
> the latest 3.5 kernel and see if the problem still affects you there?
> 
>     	       	      	      	 - Ted
