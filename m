From: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 2/2] ext3: Avoid rec_len overflow with 64KB block size
Date: Mon, 1 Oct 2007 18:01:25 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0710011801000.25158@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com>  <20070828190735.292638294@sgi.com>
  <1188432669.3799.35.camel@localhost.localdomain>
 <1188434857.3799.76.camel@localhost.localdomain> <1191285380.11737.60.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ext4 development <linux-ext4@vger.kernel.org>, sho@tnes.nec.co.jp,
	Jan Kara <jack@suse.cz>, akmp@osdl.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56518 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752326AbXJBBB0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Oct 2007 21:01:26 -0400
In-Reply-To: <1191285380.11737.60.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[Note that these will also be useful for 64K IA64 configurations]

Acked-by: Christoph Lameter <clameter@sgi.com>
