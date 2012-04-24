From: Alex Elder <elder@dreamhost.com>
Subject: Re: [PATCH, RFC 0/3] Introduce new O_HOT and O_COLD flags
Date: Tue, 24 Apr 2012 11:07:57 -0500
Message-ID: <4F96CFDD.2070001@dreamhost.com>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1334863211-19504-1-git-send-email-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 04/19/2012 02:20 PM, Theodore Ts'o wrote:
> As I had brought up during one of the lightning talks at the Linux
> Storage and Filesystem workshop, I am interested in introducing two new
> open flags, O_HOT and O_COLD.  These flags are passed down to the
> individual file system's inode operations' create function, and the file
> system can use these flags as a hint regarding whether the file is
> likely to be accessed frequently or not.
>
> In the future I plan to do further work on how ext4 would use these
> flags, but I want to first get the ability to pass these flags plumbed
> into the VFS layer and the code points for O_HOT and O_COLD reserved.

Consider this:  Is this a testable feature?

You're proposing a hint, of course, so it could just have no effect.
But let's just assume for the sake of discussion that it has been
implemented.

How will I (filesystem implementer) know whether I have implemented
it correctly?

How can the user verify that the use of these flags is producing
the expected result?

					-Alex
