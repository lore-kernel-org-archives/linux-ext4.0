From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] ext2: skip pages past number of blocks in
 ext2_find_entry
Date: Thu, 21 Dec 2006 11:14:22 -0800
Message-ID: <20061221111422.38c58e5f.randy.dunlap@oracle.com>
References: <458AD954.7020904@redhat.com>
	<20061221110549.bf336c02.randy.dunlap@oracle.com>
	<458ADC45.3050308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:13130 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423037AbWLUTOp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Dec 2006 14:14:45 -0500
To: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <458ADC45.3050308@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 21 Dec 2006 13:11:01 -0600 Eric Sandeen wrote:

> Randy Dunlap wrote:
> 
> > Please don't hide the goto; un-indent 1 tab stop.
> Whoops, thanks Randy - it wasn't intentional. :)

Yeah, I didn't think it was.  Sorry if it sounded like that.

---
~Randy
