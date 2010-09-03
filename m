From: Florian Weimer <fweimer@bfk.de>
Subject: Re: [PATCH 2/3] lib: improve the performance of memcpy and memmove of the general version
Date: Fri, 03 Sep 2010 11:03:37 +0000
Message-ID: <82mxrzrsvq.fsf@mid.bfk.de>
References: <4C7E2CAC.6080102@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C7E2CAC.6080102@cn.fujitsu.com> (Miao Xie's message of "Wed\, 01 Sep 2010 18\:36\:28 +0800")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

* Miao Xie:

>  EXPORT_SYMBOL(memcpy);

I think you need to change that to EXPORT_SYMBOL_GPL, because the code
is now licensed under the GPL, and not the GPL plus kernel exceptions
(whatever they are, but they undoubtly exist), unlike the original
implementation.

--=20
=46lorian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstra=DFe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
