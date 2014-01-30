From: Luca Ognibene <luca.ognibene@gmail.com>
Subject: Re: same ext4 file system corruption on different machines
Date: Thu, 30 Jan 2014 12:02:47 +0100
Message-ID: <1391079767.2680.18.camel@snow.station>
References: <1390999955.2601.22.camel@snow.station>
	 <1391000743.2601.26.camel@snow.station> <20140129173826.GA30419@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140129173826.GA30419@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Il giorno mer, 29/01/2014 alle 12.38 -0500, Theodore Ts'o ha scritto:
> On Wed, Jan 29, 2014 at 02:05:43PM +0100, Luca Ognibene wrote:
> > I say "same ext4 file system corruption" because e2fsck reports errors
> > on inodes around 127233 on all file systems.a I'm not sure about the
> > syslog errors because i have syslog logs for only the latest faulty
> > partition.
> 

Sorry i made a mistake in the first email. These dom drives are IDE, not
SATA.

ciao
Luca
