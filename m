From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: Tree for Aug 30 (jbd2 + bug.h)
Date: Wed, 31 Aug 2011 13:14:29 -0700
Message-ID: <20110831131429.0513af51.rdunlap@xenotime.net>
References: <20110830171605.168f29decb0558fa31e59210@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-ext4@vger.kernel.org
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20110830171605.168f29decb0558fa31e59210@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 30 Aug 2011 17:16:05 +1000 Stephen Rothwell wrote:

> Hi all,

[Sorry about the delay.  My build machine is being slow.
If this is alread fixed, sorry about the noise.]


When CONFIG_BUG is not enabled (I see this on x86_64):

fs/jbd2/transaction.c: In function 'jbd2_journal_dirty_metadata':
fs/jbd2/transaction.c:1176: error: implicit declaration of function '__WARN'


asm-generic/bug.h does not provide a version of __WARN() when
CONFIG_BUG is not enabled...


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
