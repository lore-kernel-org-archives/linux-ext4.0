From: Roel Kluin <12o3l@tiscali.nl>
Subject: Re: [PATCH] [Coding Style]: fs/ext{3,4}/ext{3,4}_jbd{,2}.c
Date: Fri, 11 Jan 2008 13:27:00 +0100
Message-ID: <47876094.8030509@tiscali.nl>
References: <1199452896-20145-5-git-send-email-mathieu.segaud@regala.cx> <477E379F.4000103@student.ltu.se> <20080105041228.GP3351@webber.adilger.int> <20080105051817.GD27894@ZenIV.linux.org.uk> <4786883E.30604@tiscali.nl> <20080111030945.27954.qmail@cdy.org> <20080111034240.GA29861@linux-sh.org> <47873ABA.5050604@tiscali.nl> <20080111102930.GA31581@linux-sh.org> <47874D2E.2000603@tiscali.nl> <20080111112353.GA31938@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Paul Mundt <lethal@linux-sh.org>, Roel Kluin <12o3l@tiscali.nl>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Mathieu Segaud <mathieu.segaud@regala.cx>,
	Richard Knutsson <ricknu-0@student.ltu.s
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:43800 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758390AbYAKM1N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jan 2008 07:27:13 -0500
In-Reply-To: <20080111112353.GA31938@linux-sh.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Paul Mundt wrote:
> On Fri, Jan 11, 2008 at 12:04:14PM +0100, Roel Kluin wrote:
>> Paul Mundt wrote:
>>> Take a look at how CONFIG_PCMCIA_DEBUG is handled.
>> In drivers/pcmcia/Makefile, when CONFIG_PCMCIA_DEBUG=y, it  gives
>> EXTRA_CFLAGS += -DDEBUG
>> which causes the definition of DEBUG as a macro, with definition 1.
>>
>>> With DEBUG()->pr_debug() conversion here you've silently dropped the
>>> __func__ prefixing. Note that dev_dbg() is usually preferred when you can
>>> get a hold of a struct device pointer, as it takes care of prettifying
>>> the output with the driver name and so on, rather than the convention of
>>> adding a prefix. If you can't get at the struct device pointer, you'll
>>> probably just want to insert the __func__ prefixing manually at the
>>> callsites.

> You're still changing the semantics here. The DEBUG() does __FUNCTION__
> prefixing, while pr_debug() does not. This should be something like
> pr_debug("%s: ....", __func__, ...); instead, if you want to maintain
> consistency. Beyond that, this looks fine, yes.

Somehow I overlooked your last point. Well, the original code had no
semantics - it wasn't working - but I get your point.

Below a patch to print the __func__'s. Note that all pr_debugs are in the
same function. Maybe the function name should be printed in the first
pr_debug only? If desired, I'll send another patch.
--
Replace printk wrapper - with a syntax error - by pr_debug; keep printing
the __func__'s. (DEBUG is defined 1 when CONFIG_PCMCIA_DEBUG is set)

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/pcmcia/au1000_xxs1500.c b/drivers/pcmcia/au1000_xxs1500.c
index ce9d5c4..b4bad6e 100644
--- a/drivers/pcmcia/au1000_xxs1500.c
+++ b/drivers/pcmcia/au1000_xxs1500.c
@@ -55,12 +55,6 @@
 #define PCMCIA_NUM_SOCKS	(PCMCIA_MAX_SOCK + 1)
 #define PCMCIA_IRQ		AU1000_GPIO_4
 
-#if 0
-#define DEBUG(x,args...)	printk(__FUNCTION__ ": " x,##args)
-#else
-#define DEBUG(x,args...)
-#endif
-
 static int xxs1500_pcmcia_init(struct pcmcia_init *init)
 {
 	return PCMCIA_NUM_SOCKS;
@@ -143,13 +137,13 @@ xxs1500_pcmcia_configure_socket(const struct pcmcia_configure *configure)
 
 	if(configure->sock > PCMCIA_MAX_SOCK) return -1;
 
-	DEBUG("Vcc %dV Vpp %dV, reset %d\n",
+	pr_debug("%s: Vcc %dV Vpp %dV, reset %d\n", __func__,
 			configure->vcc, configure->vpp, configure->reset);
 
 	switch(configure->vcc){
 		case 33: /* Vcc 3.3V */
 			/* turn on power */
-			DEBUG("turn on power\n");
+			pr_debug("%s: turn on power\n", __func__);
 			au_writel((au_readl(GPIO2_PINSTATE) & ~(1<<14))|(1<<30),
 					GPIO2_OUTPUT);
 			au_sync_delay(100);
@@ -166,7 +160,7 @@ xxs1500_pcmcia_configure_socket(const struct pcmcia_configure *configure)
 	}
 
 	if (!configure->reset) {
-		DEBUG("deassert reset\n");
+		pr_debug("%s: deassert reset\n", __func__);
 		au_writel((au_readl(GPIO2_PINSTATE) & ~(1<<4))|(1<<20),
 				GPIO2_OUTPUT);
 		au_sync_delay(100);
@@ -174,7 +168,7 @@ xxs1500_pcmcia_configure_socket(const struct pcmcia_configure *configure)
 				GPIO2_OUTPUT);
 	}
 	else {
-		DEBUG("assert reset\n");
+		pr_debug("%s: assert reset\n", __func__);
 		au_writel(au_readl(GPIO2_PINSTATE) | (1<<4)|(1<<20),
 				GPIO2_OUTPUT);
 	}
