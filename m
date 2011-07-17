From: Felipe Wilhelms Damasio - Taghos <felipewd@taghos.com.br>
Subject: Re: Ext4 flush blocked
Date: Sun, 17 Jul 2011 15:54:15 -0300
Message-ID: <4E232FD7.609@taghos.com.br>
References: <4E1F95B8.4050005@taghos.com.br> <4E1F9796.5020107@taghos.com.br> <4E1FB492.4070300@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gateway08.websitewelcome.com ([67.18.36.18]:35241 "HELO
	gateway08.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756135Ab1GQTLe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jul 2011 15:11:34 -0400
Received: from gator1481.hostgator.com (gator1481.hostgator.com [184.173.199.228])
	by ham.websitewelcome.com (Postfix) with ESMTP id A04065265C76D
	for <linux-ext4@vger.kernel.org>; Sun, 17 Jul 2011 13:54:29 -0500 (CDT)
In-Reply-To: <4E1FB492.4070300@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

    Hi Tao,

Em 15/07/2011 00:31, Tao Ma escreveu:
> Is there something I can try to fix this?
> could you please try to change io scheduler to 'deadline'?
> We have met with some similar warnings and changing to 'deadline' makes
> ext4 happy.
    The symptoms were away after changing the system to use deadline
scheduler, thanks.

    Cheers,

-- 
Felipe Wilhelms Damasio
TAGHOS - Tecnologia
Rua Prof. Alvaro Alvim, 211
Porto Alegre - RS - (51) 3239-3180
www.taghos.com.br <http://www.taghos.com.br/>

