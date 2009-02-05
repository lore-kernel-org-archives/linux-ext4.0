From: Trilok Soni <soni.trilok@gmail.com>
Subject: Re: [ltt-dev] LTTng 0.89 for Linux 2.6.29-rc3
Date: Thu, 5 Feb 2009 21:52:16 +0530
Message-ID: <5d5443650902050822r2e4d08ffg2322b45a5e009fb8@mail.gmail.com>
References: <20090130200757.GA14999@Krystal>
	 <20090205140432.GE6915@linux.vnet.ibm.com>
	 <20090205150242.GA27895@Krystal>
	 <20090205151841.GF6915@linux.vnet.ibm.com>
	 <20090205153825.GA30255@Krystal>
	 <20090205155854.GG6915@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	ltt-dev@lists.casi.polymtl.ca,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
To: paulmck@linux.vnet.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.180]:21645 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbZBEQWs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Feb 2009 11:22:48 -0500
In-Reply-To: <20090205155854.GG6915@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Paul,

On Thu, Feb 5, 2009 at 9:28 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>>
>> Are you using quilt to apply the patchset series file in the right order ?
>
> Ummm...  No.  I never have used quilt.
>
> Ah, there is a series file.  I guess it would not be too hard to make
> an appropriate "sh" command:
>

How about trying?


#quilt push -a

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
