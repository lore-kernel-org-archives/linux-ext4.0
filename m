From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
Date: Wed, 18 Jun 2008 23:09:03 -0700
Message-ID: <4859F7FF.2010406@linux.intel.com>
References: <4859EFE2.2090202@linux.intel.com> <alpine.LFD.1.10.0806182242390.2907@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756884AbYFSGJb@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0806182242390.2907@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Linus Torvalds wrote:
> Or could this perhaps be an indication that it is specific to i686 some 
> way (eg a compiler issue?)
> 

Dave Airlie just confirmed this is a compiler bug indeed in gcc 4.3.1
and pointed at https://bugzilla.redhat.com/show_bug.cgi?id=451068
