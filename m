From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC][PATCH 00/12] Enhanced file stat system call
Date: Tue, 24 Nov 2015 06:43:38 -0800
Message-ID: <5654779A.9000702@schaufler-ca.com>
References: <20151120145422.18930.72662.stgit@warthog.procyon.org.uk>
 <564F4F4E.8060603@schaufler-ca.com> <20151124081519.GA16147@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Howells <dhowells@redhat.com>, arnd@arndb.de,
	linux-afs@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151124081519.GA16147@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 11/24/2015 12:15 AM, Christoph Hellwig wrote:
> On Fri, Nov 20, 2015 at 08:50:22AM -0800, Casey Schaufler wrote:
>> How about relevant xattrs? SELinux context, ACL, that sort of thing.
>> The fact that these are optional should be taken care of by (4).
> Those are not simple, fixed size stat data and would make the system
> call a giant mess.
>
I didn't say it would be easy. I do think that adding a system call
that only deals with simple, fixed size data is going to fall short
of solving "the problem".

Actually, a Smack label is fixed size (256 bytes). I suspect there
is a maximum for SELinux contexts as well. ACLs I'll grant you are
infinite.
