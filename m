From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: fiemap is broken for sparse file in ext4?
Date: Fri, 11 Jun 2010 10:46:52 -0500
Message-ID: <4C125A6C.2090805@redhat.com>
References: <4C119C2E.2090801@oracle.com> <4C11B6D8.8070909@redhat.com> <4C11C41C.9070000@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org
To: Tao Ma <tao.ma@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C11C41C.9070000@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Tao Ma wrote:

>> What are you using to call fiemap?  Here it seems to be working:
> I just wrote a simple test program by calling ioctl. It is attached.
> btw, you need to call it immediately after dd so that we have a chance
> that ext4 don't have time to allocate extents. ;)

OK I take it back, I do see it.  *cough* too many different filesystems
on this box ... ;)

Yes, it does look like a bug.

-Eric
