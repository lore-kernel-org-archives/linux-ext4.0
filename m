From: Theodore Tso <tytso@mit.edu>
Subject: Re: Problem with delayed allocation
Date: Tue, 5 Aug 2008 02:44:28 -0400
Message-ID: <20080805064428.GB8569@mit.edu>
References: <E1KPNNn-0003IN-0B@closure.thunk.org> <20080804163505.GE9397@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47899 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752619AbYHEGob (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Aug 2008 02:44:31 -0400
Content-Disposition: inline
In-Reply-To: <20080804163505.GE9397@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2008 at 10:05:05PM +0530, Aneesh Kumar K.V wrote:
> 
> This is the complete patch that  I have. I haven't fully tested it
> (right now waiting for the machine to be free). This should apply 
> after stable-boundary-undo.patch

Umm... the patch doesn't apply right after the stable boundary udo
patch.

						- Ted
