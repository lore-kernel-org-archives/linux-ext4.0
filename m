From: Jason Pepas <jasonpepas@gmail.com>
Subject: Re: mkfs.ext2 succeeds despite nbd write errors?
Date: Sat, 7 Nov 2015 17:25:27 -0600
Message-ID: <CALuDM+DHATW=KvM0XeREygrA5z=6U1n+UyBqv8juXx7mXHa4UA@mail.gmail.com>
References: <CALuDM+AtyUUMFcdTOocxCw9BxQ4PBx5aeYVYwmy_UErh1MZjww@mail.gmail.com>
	<20151107110354.GM1908@redhat.com>
	<CALuDM+Aw9JCMVbQcRKaaUu+=+xvDpMgL8sUZpT2snz9Qp5DqpA@mail.gmail.com>
	<20151107210203.GW29330@redhat.com>
	<CALuDM+CAE1g8-9g9_72hU3xcQnA5k8QTkSQj4rjHh2tHc8mgLw@mail.gmail.com>
	<20151107232001.GX29330@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, libguestfs@redhat.com
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <libguestfs-bounces@redhat.com>
In-Reply-To: <20151107232001.GX29330@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/libguestfs>,
	<mailto:libguestfs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/libguestfs>
List-Post: <mailto:libguestfs@redhat.com>
List-Help: <mailto:libguestfs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/libguestfs>,
	<mailto:libguestfs-request@redhat.com?subject=subscribe>
Sender: libguestfs-bounces@redhat.com
Errors-To: libguestfs-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Sat, Nov 7, 2015 at 5:20 PM, Richard W.M. Jones <rjones@redhat.com> wrote:
> I'm definitely not an expert here, but I do recall being told that
> writes and reads are allowed to return an "OK" indication, but a later
> close(2) or fsync(2) might fail.  That is particularly a problem with NFS.
>
> I'll leave the rest to the true experts on the ext4 mailing list.

Thanks for you help!  I'll move the rest of this discussion to their
mailing list.

-jason
