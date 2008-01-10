From: Roel Kluin <12o3l@tiscali.nl>
Subject: Re: [PATCH] [Coding Style]: fs/ext{3,4}/ext{3,4}_jbd{,2}.c
Date: Thu, 10 Jan 2008 22:03:58 +0100
Message-ID: <4786883E.30604@tiscali.nl>
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-4-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-5-git-send-email-mathieu.segaud@regala.cx> <477E379F.4000103@student.ltu.se> <20080105041228.GP3351@webber.adilger.int> <20080105051817.GD27894@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Richard Knutsson <ricknu-0@student.ltu.se>,
	Mathieu Segaud <mathieu.segaud@regala.cx>,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756980AbYAJVEV@vger.kernel.org>
In-Reply-To: <20080105051817.GD27894@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Al Viro wrote:
> __func__ is C99, but it's not what __FUNCTION__ used to be - it's not a
> string literal.  6.4.2.2(1):
> 
> 	The identifier __func__ shall be implicitly declared by the translator
> as if, immediately following the opening brace of each function definition,
> the declaration
> 	static const char __func__[] = "function-name";
> appeared, where function-name is the name of the lexically-enclosing function.
> 
> IOW, it's a phase 7 (parsing and translation of translation units) and not
> phase 4 (preprocessor).  Practical implications are:
> 	* _way_ fewer kludges
> 	* it happens after phase 6 (string literal concatenation)
> So __FUNCION__ " is called" within body of foo() would result in
> "foo is called" while __func__ "is called" is a syntax error.
> 
> These days old gcc __FUNCTION__ is gone; it's a macro expanding to __func__,
> so behaviour does *not* match the original (see above).

so if I understand correctly, this requires a fix:
--
__FUNCTION__ is a macro expanding to __func__ and translated as if previously
in that function was declared:
	static const char __func__[] = "function-name";

As is DEBUG() - when active - will produce a syntax error.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/pcmcia/au1000_xxs1500.c b/drivers/pcmcia/au1000_xxs1500.c
index ce9d5c4..855e1d6 100644
--- a/drivers/pcmcia/au1000_xxs1500.c
+++ b/drivers/pcmcia/au1000_xxs1500.c
@@ -56,7 +56,7 @@
 #define PCMCIA_IRQ		AU1000_GPIO_4
 
 #if 0
-#define DEBUG(x,args...)	printk(__FUNCTION__ ": " x,##args)
+#define DEBUG(x, args...)	printk("%s: ", __func__, x, ##args)
 #else
 #define DEBUG(x,args...)
 #endif

