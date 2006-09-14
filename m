From: Peter Staubach <staubach@redhat.com>
Subject: Re: rfc: [patch] change attribute for ext3
Date: Thu, 14 Sep 2006 09:46:03 -0400
Message-ID: <45095D1B.8040201@redhat.com>
References: <20060913164202.GA14838@openx1.frec.bull.fr>
	<1158171071.6072.10.camel@lade.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alexandre Ratchov <alexandre.ratchov@bull.net>, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
Return-path: <nfsv4-bounces@linux-nfs.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
In-Reply-To: <1158171071.6072.10.camel@lade.trondhjem.org>
List-Unsubscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=unsubscribe>
List-Archive: <http://linux-nfs.org/pipermail/nfsv4>
List-Post: <mailto:nfsv4@linux-nfs.org>
List-Help: <mailto:nfsv4-request@linux-nfs.org?subject=help>
List-Subscribe: <http://linux-nfs.org/cgi-bin/mailman/listinfo/nfsv4>,
	<mailto:nfsv4-request@linux-nfs.org?subject=subscribe>
Sender: nfsv4-bounces@linux-nfs.org
Errors-To: nfsv4-bounces@linux-nfs.org
List-Id: linux-ext4.vger.kernel.org

Trond Myklebust wrote:
> On Wed, 2006-09-13 at 18:42 +0200, Alexandre Ratchov wrote:
>   
>> hello, 
>>
>> here is a small patch that adds the "change attribute" for ext3
>> file-systems;
>>
>> the change attribute is a simple counter that is reset to zero on
>> inode creation and that is incremented every time the inode data is
>> modified (similarly to the "ctime" time-stamp).
>>     
>
> I would really have preferred a full-blown 64-bit counter as per
> RFC3530, but I suppose we could always combine this change attribute
> with the high word from ctime in order to make up the NFSv4 change
> attribute. That should keep us safe until someone develops a ramdisk
> with < 1 nsecond access time.

Wouldn't the generation count work better than ctime to differentiate 
between
instances of files using the same inode number?  That way, there wouldn't be
a clock resolution issue.

    Thanx...

       ps
