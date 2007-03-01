From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Thu, 01 Mar 2007 14:15:58 -0800
Message-ID: <45E7509E.7090000@goop.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com>	<20070225022326.137b4875.akpm@linux-foundation.org>	<20070301183445.GA7911@amitarora.in.ibm.com>	<45E74238.3040606@goop.org>	<20070301225855.24ecaba0@lxorguk.ukuu.org.uk>	<45E74E30.8080909@goop.org> <20070301231118.427544a4@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
To: Alan <alan@lxorguk.ukuu.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070301231118.427544a4@lxorguk.ukuu.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Alan wrote:
> ENOSYS indicates quite different things and ENOTTY is also used for
> syscalls. I still think ENOTTY is correct.
>   
Yes, ENOSYS tends to me "operation flat out not support" rather than
"not on this object".  I think we can do better than ENOTTY though -
ENOTSUP for example (modulo the confusion over EOPNOTSUPP).

(You can tell the patch has very little real substance if we're arguing
over errnos at this point :)

    J
