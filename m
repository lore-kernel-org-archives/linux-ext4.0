From: Carlos Carvalho <carlos@fisica.ufpr.br>
Subject: Re: why has "fix ext4_ext_remove_space tree traversal" not been applied?
Date: Tue, 6 Nov 2012 10:15:14 -0200
Message-ID: <20632.65362.300954.75766@fisica.ufpr.br>
References: <20632.64737.272834.202562@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fisica.ufpr.br ([200.17.209.129]:24982 "EHLO fisica.ufpr.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab2KFMPR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 6 Nov 2012 07:15:17 -0500
In-Reply-To: <20632.64737.272834.202562@fisica.ufpr.br>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Carlos Carvalho (carlos@fisica.ufpr.br) wrote on 6 November 2012 10:04:
 >In 3.6.6 some of the patches of the series "Bunch of DIO/AIO fixes V4"
 >by Dmitry Monakhov have been applied but not all. In particular, patch
 >9, "fix ext4_ext_remove_space tree traversal" is not there. We're
 >getting hit by the null pointer dereference in our main file servers.
 >
 >What's the situation of this patch? Any reason it's not applied?

More precisely, we're getting hit in 3.5.2. I'm asking if 3.6.6 has an
equivalent patch. Here's a link: http://patchwork.ozlabs.org/patch/183649/
