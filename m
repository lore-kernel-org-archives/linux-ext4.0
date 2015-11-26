From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [[PATCH] fix an endianness bug in ext4_encrypted_zeroout()
Date: Thu, 26 Nov 2015 15:21:44 -0500
Message-ID: <20151126202144.GD2632@thunk.org>
References: <20151126160434.GU22011@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151126160434.GU22011@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 26, 2015 at 04:04:34PM +0000, Al Viro wrote:
> ex->ee_block is not host-endian (note that accesses of other fields
> of *ex right next to that line go through the helpers that do proper
> conversion from little-endian to host-endian; it might make sense
> to add similar for ->ee_block to avoid reintroducing that kind of
> bugs...)
> 
> Cc: stable@vger.kernel.org # v4.1+
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Thanks for catching this!   Applied.

							- Ted
