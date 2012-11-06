From: Carlos Carvalho <carlos@fisica.ufpr.br>
Subject: Re: why has "fix ext4_ext_remove_space tree traversal" not been
 applied?
Date: Tue, 6 Nov 2012 11:48:19 -0200
Message-ID: <20633.5411.781195.220149@fisica.ufpr.br>
References: <20632.64737.272834.202562@fisica.ufpr.br>
	<20121106131751.GA3242@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fisica.ufpr.br ([200.17.209.129]:24982 "EHLO fisica.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab2KFNsV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2012 08:48:21 -0500
In-Reply-To: <20121106131751.GA3242@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o (tytso@mit.edu) wrote on 6 November 2012 08:17:
 >On Tue, Nov 06, 2012 at 10:04:49AM -0200, Carlos Carvalho wrote:
 >> In 3.6.6 some of the patches of the series "Bunch of DIO/AIO fixes V4"
 >> by Dmitry Monakhov have been applied but not all. In particular, patch
 >> 9, "fix ext4_ext_remove_space tree traversal" is not there. We're
 >> getting hit by the null pointer dereference in our main file servers.
 >> 
 >> What's the situation of this patch? Any reason it's not applied?
 >
 >Patches which which change a large amount of code don't get the
 >cc:stable@vger.kernel.org label applied to them, primarily because of
 >the risk involved and the likelihood that those patches won't easily
 >get backported to the older stable kernels.

Sure. I asked because we're having serious problems with a released
version (3.5.2), so an available fix should have already been applied
somewhere and I didn't recognize it. Dmitry sent the link that shows
this is the case. Now we'll go to 3.6.6.
