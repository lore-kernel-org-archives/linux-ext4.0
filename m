From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][2/15] e2fsprogs-config-before-cmdline.patch
Date: Tue, 07 Oct 2008 02:56:06 -0600
Message-ID: <20081007085606.GS2009@webber.adilger.int>
References: <1223289068.4007.84.camel@localhost> <20081006204926.GA8139@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Kalpak Shah <Kalpak.Shah@sun.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64101 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbYJGI4V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Oct 2008 04:56:21 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m978uIZD013340
	for <linux-ext4@vger.kernel.org>; Tue, 7 Oct 2008 01:56:20 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K8D0050123MDZ00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 07 Oct 2008 01:56:18 -0700 (PDT)
In-reply-to: <20081006204926.GA8139@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Oct 06, 2008  16:49 -0400, Theodore Ts'o wrote:
> On Mon, Oct 06, 2008 at 04:01:08PM +0530, Kalpak Shah wrote:
> > The patch changes the order that the config file and command line are
> > parsed so that command line has precedence.  It also adds a check to
> > make sure only one -E option is passed on the command line as -E option
> > parsing is not cumulative.
> 
> Hmm.  I wonder if we would be better off making -E option parsing
> cumulative, especially if we are going to add a way of specifying some
> extended options via the config file.  Comments?

I've always thought that both -E and -O should be cumulative.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

