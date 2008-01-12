From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Fwd: [Bug 9732] New: oops in extent code via ext4_fallocate]
Date: Sat, 12 Jan 2008 10:44:55 -0600
Message-ID: <4788EE87.5040007@redhat.com>
References: <4787D498.1050202@redhat.com> <20080112163144.GA6546@skywalker> <4788ED9E.3090207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbYALQqC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Jan 2008 11:46:02 -0500
In-Reply-To: <4788ED9E.3090207@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> [root@bear-05 sdb8]# ./testfallocate -f testfile 0 32768
> [root@bear-05 sdb8]# ./testfallocate -f testfile 16384 65536

(oh, for completeness I started with a fresh 0 length, 0 size file):

# rm -f testfile; touch testfile
<testfallocate tests>

-Eric
