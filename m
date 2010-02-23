From: Jan Kara <jack@ucw.cz>
Subject: Re: [ANNOUNCE] Online Hierarchical Storage Manager (OHSM v1.2)
Date: Tue, 23 Feb 2010 15:27:35 +0100
Message-ID: <20100223142735.GB7699@atrey.karlin.mff.cuni.cz>
References: <ea11fea31002222148u4abe8235q4bb7ef855044b508@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, ohsm-devel@lists.sourceforge.net,
	kernelnewbies@nl.linux.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:60931 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752524Ab0BWO1g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Feb 2010 09:27:36 -0500
Content-Disposition: inline
In-Reply-To: <ea11fea31002222148u4abe8235q4bb7ef855044b508@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Manish,

>    We are pleased to announce the first official functional release of Online
> Hierarchical Storage Manager (OHSM v1.2).  This is a RFC release and
> not yet aimed at mainline inclusion.
> 
> OHSM is a tool to manage and move data across various class of storage.
> It can help users to selectively place and move data across tiers such
> as SSD, Raid 10, Raid 6 based on the attributes of the data. OHSM
> supports background movement of data
> without any visible change in a files namespace to users and user applications.
> OHSM is built as an external module with recompilation required for
> ext4. The current version of OHSM is based upon kernel 2.6.32.2
> 
> This release includes 3 core kernel patches:
> 
> 1) An initial ext4 patch to adjust ext4's block allocation to use a
> preferred block range per Ted
> Tso's Dec 2008 write-up
> (http://markmail.org/message/qp7zjhhdzxum7rfn).  This patch is not
> ohsm specific.
> 2) A ohsm specific ext4 patch to provide callouts to the ohsm module.
> 3) The ohsm module itself
> 
> The source code for OHSM v1.2 is freely distributable under GPL.
> The latest stable OHSM v1.2 is available at :
> http://sourceforge.net/projects/ohsm/files/OHSMv1.2.tar.gz/download
> Sources are available as git repository at :
> git://ohsm.git.sourceforge.net/gitroot/ohsm/ohsm
  Looking at the code, the code deciding where to put a given file isn't
really tied to ext4, is it?
  Using pathnames to decide where to put files is ... natural but it has
its downsides. For example your code in build_path() is racy because the
directory hiearchy can change while you climb the tree - not mentioning the
fact that the static buffer of 4096 for pathname is ugly and implementing
that simple walk recursively isn't good either. Kernel already has a d_path
function for constructing path in at least somewhat reliable way.
  Anyway I suggest you have a look at Tomoyo which implements pathname based
security module so that you can avoid mistakes they did...

								Honza

