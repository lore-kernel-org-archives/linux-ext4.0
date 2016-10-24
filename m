From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] MAINTAINERS: fscrypto: recommend
 linux-fsdevel for fscrypto patches
Date: Mon, 24 Oct 2016 22:44:41 +0200
Message-ID: <8426b631-dc03-b45a-ec58-fc3ae5cdf0c9@nod.at>
References: <1477340955-145575-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jaegeuk@kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
To: Eric Biggers <ebiggers@google.com>, linux-fsdevel@vger.kernel.org
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1477340955-145575-1-git-send-email-ebiggers@google.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On 24.10.2016 22:29, Eric Biggers wrote:
> The filesystem level encryption support, currently used by ext4 and f2fs
> and proposed for ubifs, does not yet have a dedicated mailing list.
> Since no mailing lists were specified in MAINTAINERS, get_maintainer.pl
> only recommended to send patches directly to the maintainers and to
> linux-kernel.  This patch adds linux-fsdevel as the preferred mailing
> list for fscrypto patches for the time being.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ea4fbc9..d3ce20e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5123,6 +5123,7 @@ F:	include/linux/fscache*.h
>  FS-CRYPTO: FILE SYSTEM LEVEL ENCRYPTION SUPPORT
>  M:	Theodore Y. Ts'o <tytso@mit.edu>
>  M:	Jaegeuk Kim <jaegeuk@kernel.org>
> +L:	linux-fsdevel@vger.kernel.org
>  S:	Supported
>  F:	fs/crypto/
>  F:	include/linux/fscrypto.h

That's a very good idea!
Do we also have designated git tree for fscrypto?
As soon UBIFS file encryption is mainline I'll have to monitor changes
to fscrypto very closely because changes in fscrypto could introduce
changes in the on-flash format of UBIFS.
i.e. a subtle change in filename encryption... :-)

Thanks,
//richard

------------------------------------------------------------------------------
The Command Line: Reinvented for Modern Developers
Did the resurgence of CLI tooling catch you by surprise?
Reconnect with the command line and become more productive. 
Learn the new .NET and ASP.NET CLI. Get your free copy!
http://sdm.link/telerik
