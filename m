From: Tejun Heo <tj@kernel.org>
Subject: Re: 2.6.32.4 - still getting ext4 related crashes
Date: Thu, 11 Feb 2010 11:27:44 +0900
Message-ID: <4B736B20.4070703@kernel.org>
References: <20100122085035.GA5020@nik-nb2.linuxbox.cz> <20100122213827.GH21263@thunk.org> <20100124071943.GA4407@nik-comp.linuxbox.cz> <20100124094853.GA4382@thunk.org> <20100126204754.GA4637@nik-comp.linuxbox.cz> <4B60A4A6.3070001@redhat.com> <20100128172442.GA531@develbox.linuxbox.cz> <4B61D4A2.5020407@redhat.com> <20100128183639.GA546@develbox.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, tytso@mit.edu,
	Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
	ext4 maillist <linux-ext4@vger.kernel.org>,
	IDE/ATA development list <linux-ide@vger.kernel.org>,
	mzik@linuxbox.cz
To: Nikola Ciprich <extmaillist@linuxbox.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:34964 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755100Ab0BKCZj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Feb 2010 21:25:39 -0500
In-Reply-To: <20100128183639.GA546@develbox.linuxbox.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/29/2010 03:36 AM, Nikola Ciprich wrote:
> Nope, anything. That's why I first posted it to ext4 list, but now it
> seems to me it might be hw related...

Maybe testing on raw block device is a good idea to rule out the
filesystem?

Thanks.

-- 
tejun
